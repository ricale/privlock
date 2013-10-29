class Category < ActiveRecord::Base
  belongs_to :parent, class_name: 'Category'
  has_many :children, class_name: 'Category', foreign_key: 'parent_id'

  validates :name, presence: true

  validates :family,
            :depth,
            :order_in_parent,
            numericality: { greater_than_or_equal_to: 0 }

  before_validation :if_parent_no_exist_parent_id_must_be_nil
  
  before_validation :initialize_family, on: :create
  before_validation :initialize_depth, on: :create
  before_validation :initialize_order_in_parent, on: :create

  before_validation :is_not_circular_error, on: :update, if: :parent_id_changed?

  after_update :change_attributes_on_update, if: :parent_id_changed?

  scope :root_categories, -> { where(parent_id: nil) }
  scope :child_categories, ->(parent_id) { where(parent_id: parent_id).order(:order_in_parent) }
  scope :except_one, ->(id) { where("id != ?", id) }
  scope :child_categories_array, ->(parent_id) { child_categories(parent_id).map { |c| c } }
  #scope :child_categories_attributes, ->(parent_id) { child_categories(parent_id).map { |c| c.attributes.symbolize_keys } }

  def self.hierarchy_categories(root_id)
    root_id = nil if root_id == :all
    
    hierarchy(Category.child_categories_array(root_id))
  end

  protected

  def if_parent_no_exist_parent_id_must_be_nil
    if Category.where(id: parent_id).empty?
      self.parent_id = nil
    end
  end

  def initialize_family
    if parent
      self.family = parent.family
    else
      last_family = Category.root_categories.maximum(:family)
      self.family = last_family + 1 if last_family
    end
  end

  def initialize_depth
    self.depth = parent ? parent.depth + 1 : 0
  end

  def initialize_order_in_parent
    if parent
      last_order = Category.child_categories(parent_id).maximum(:order_in_parent)
      self.order_in_parent = last_order + 1 if last_order
    end
  end

  def is_not_circular_error
    category = self

    while category.parent do
      category = category.parent
      return false if category == self
    end
  end

  def change_attributes_on_update
    prev_family = family
    prev_depth  = depth

    update_family
    update_depth
    update_order_in_parent

    update_children_family if prev_family != family
    update_children_depth  if prev_depth  != depth
  end



  def update_family
    initialize_family
    update_column(:family, family)
  end

  def update_depth
    initialize_depth
    update_column(:depth, depth)
  end

  def update_order_in_parent
    if parent
      last_order = Category.child_categories(parent_id).except_one(id).maximum(:order_in_parent)
      self.order_in_parent = last_order ? last_order + 1 : 0

      update_column(:order_in_parent,  order_in_parent)
    else
      update_column(:order_in_parent,  0)
    end
  end

  def update_children_family
    Category.hierarchy_categories(id).each do |child|
      child.update_attributes(family: family)
    end
  end

  def update_children_depth
    update_children_depth_recursively(self)
  end

  def update_children_depth_recursively(parent)
    Category.child_categories(parent.id).each do |child|
      child.depth = parent.depth + 1
      child.save

      update_children_depth_recursively(child)
    end
  end



  def self.hierarchy(categories)
    categories.each_with_index do |category, index|
      Category.child_categories_array(category.id).reverse_each do |child|
        categories.insert(index + 1, child)
      end
    end
  end

end
