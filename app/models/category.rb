class Category < ActiveRecord::Base
  has_many :children, class_name: 'Category', foreign_key: 'parent_id'
  belongs_to :parent, class_name: 'Category'

  before_validation :set_order_in_parent_on_create, on: :create
  before_validation :set_depth_on_create, on: :create
  before_validation :set_family_on_create, on: :create

  scope :root_categories, -> { where(parent_id: nil) }
  scope :sibling_categories, ->(parent_id) { where(parent_id: parent_id) }
  scope :categories_except_one, ->(id) { where("id != ?", id) }

  protected
    def set_order_in_parent_on_create
      last_order = Category.sibling_categories(parent_id).maximum(:order_in_parent)
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

end
