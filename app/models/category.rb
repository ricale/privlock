class Category < ActiveRecord::Base
  belongs_to :parent, class_name: 'Category'
  has_many :children, class_name: 'Category', foreign_key: 'parent_id'

  before_validation :set_order_in_parent_on_create, on: :create
  before_validation :set_depth_on_create, on: :create
  before_validation :set_family_on_create, on: :create

  scope :root_categories, -> { where(parent_id: nil) }
  scope :child_categories, ->(parent_id) { where(parent_id: parent_id) }
  scope :categories_except_one, ->(id) { where("id != ?", id) }
  scope :child_categories_array, ->(parent_id) { child_categories(parent_id).map { |c| c } }
  #scope :child_categories_attributes, ->(parent_id) { child_categories(parent_id).map { |c| c.attributes.symbolize_keys } }

  def self.hierarchy_categories(root_id)
    root_id = nil if root_id == :all
    
    hierachy(Category.child_categories_array(root_id))
  end

  protected

  def set_order_in_parent_on_create
    last_order = Category.child_categories(parent_id).maximum(:order_in_parent)
    self.order_in_parent = last_order + 1 if last_order
  end

  def set_depth_on_create
    logger.info "parent_id #{parent_id}"
    self.depth = parent.depth + 1 if parent
  end

  def set_family_on_create
    if parent
      self.family = parent.family
    else
      last_family = Category.root_categories.maximum(:family)
      self.family = last_family + 1 if last_family
    end
  end

  def self.hierachy(categories)
    categories.each_with_index do |category, index|
      Category.child_categories_array(category[:id]).reverse_each do |child|
        categories.insert(index + 1, child)
      end
    end
  end

end
