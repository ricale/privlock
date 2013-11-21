class Category < ActiveRecord::Base
  belongs_to :parent, class_name: 'Category'
  has_many :children, class_name: 'Category', foreign_key: 'parent_id'
  has_many :writing

  validates :name, presence: true

  validates :depth,
            :order_in_parent,
            numericality: { greater_than_or_equal_to: 0 }

  before_validation :create_root_if_needed, on: :create
  before_validation :parent_is_root_if_parent_id_is_invalid

  before_validation :initialize_depth, on: :create
  before_validation :initialize_order_in_parent, on: :create

  before_validation :is_not_circular_error, on: :update, if: :parent_id_changed?

  before_destroy :possible_to_destroy

  after_update :change_attributes_on_update, if: :parent_id_changed?

  scope :child_categories, ->(parent_id) { where(parent_id: parent_id).order(:order_in_parent) }
  scope :except_one,       ->(id)        { where.not(id: id) }

  scope :to_array, -> { all.map { |c| c } }

  def self.hierarchy_categories(root_id, excepted_ids = [])
    root_id = nil if root_id == :all
    
    hierarchy(Category.child_categories(root_id).to_array, excepted_ids)
  end

  def up
    up_order_in_parent if parent_id != nil
  end

  def down
    down_order_in_parent if parent_id != nil
  end



  private

  # before_validation

  def create_root_if_needed
    Category.create(parent_id: nil, name: "root") if is_first_category_except_root
  end

  def parent_is_root_if_parent_id_is_invalid
    self.parent_id = Category.root.id if is_invalid_parent_id_and_root_is_exist
  end

  def is_first_category_except_root
    Category.count == 0 && (parent_id != nil || (parent_id == nil && name != "root"))
  end

  def is_invalid_parent_id_and_root_is_exist
    Category.where(id: parent_id).empty? && Category.root
  end

  #
  # before_validation, on: :create

  def initialize_depth
    self.depth = parent ? parent.depth + 1 : 0
  end

  def initialize_order_in_parent
    if parent
      last_order = Category.child_categories(parent_id).maximum(:order_in_parent)
      self.order_in_parent = last_order ? last_order + 1 : 0

    else
      self.order_in_parent = 0
    end
  end

  #
  # before_validation, on: :update

  def is_not_circular_error
    category = self

    while category.parent do
      category = category.parent
      return false if category == self
    end
  end

  #
  # before_destroy

  def possible_to_destroy
    false unless children.count == 0
    false unless writing.count == 0
    false if parent_id == nil
  end

  #
  # after_update

  def change_attributes_on_update
    prev_depth  = depth

    update_depth
    update_order_in_parent

    update_children_depth  if prev_depth  != depth
    update_sibling_order_in_parent
  end

  def update_depth
    initialize_depth
    update_columns(depth: depth)
  end

  def update_order_in_parent
    if parent
      last_order = Category.child_categories(parent_id).except_one(id).maximum(:order_in_parent)
      self.order_in_parent = last_order ? last_order + 1 : 0

      update_columns(order_in_parent: order_in_parent)
    else
      update_columns(order_in_parent: 0)
    end
  end

  def update_children_depth
    update_children_depth_recursively(self)
  end

  def update_children_depth_recursively(parent)
    Category.child_categories(parent.id).each do |child|
      child.update(depth: parent.depth + 1)

      update_children_depth_recursively(child)
    end
  end

  def update_sibling_order_in_parent
    Category.child_categories(parent_id_was)
            .where("order_in_parent > ?", order_in_parent_was).each do |sibling|

      sibling.order_in_parent -= 1
      sibling.save
    end
  end

  #
  #

  def up_order_in_parent
    move_order_in_parent(true) if order_in_parent != 0
  end

  def down_order_in_parent
    move_order_in_parent(false) if order_in_parent != Category.child_categories(parent_id).maximum(:order_in_parent)
  end

  def move_order_in_parent(up)
    offset = up ? -1 : 1
    sitten_category = Category.find_by(parent_id: parent_id, order_in_parent: order_in_parent + offset)
    sitten_category.update(order_in_parent: order_in_parent)
    update(order_in_parent: order_in_parent + offset)
  end

  #
  # class method

  def self.root
    Category.find_by(parent_id: nil)
  end

  def self.hierarchy(categories, excepted_ids)
    categories.each do |category|
      categories.delete(category) if excepted_ids.include? category.id
    end

    categories.each_with_index do |category, index|
      Category.child_categories(category.id).to_array.reverse_each do |child|
        categories.insert(index + 1, child) unless excepted_ids.include? child.id
      end
    end
  end

end
