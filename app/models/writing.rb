# == Schema Information
#
# Table name: writings
#
#  id          :integer          not null, primary key
#  title       :string(255)      not null
#  content     :text             not null
#  created_at  :datetime
#  updated_at  :datetime
#  category_id :integer          not null
#  user_id     :integer          not null
#

class Writing < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  has_many :comment

  validates_presence_of :title
  validates_presence_of :content
  validates_presence_of :category_id
  validates_presence_of :user_id

  before_validation :can_not_update_user, on: :update

  before_save :is_exist_category?
  before_save :is_admin_user?, on: :create

  scope :in_categories, ->(category_ids) { where("category_id in (?)", category_ids) }

  scope :in_category_tree, ->(category_id) {
    where("category_id in (?)", Category.hierarchy_categories(category_id).map { |c| c.id } << category_id)
  }

  def last_comment_updated_at
    Comment.last_updated_at(id)
  end


  private 

  def is_exist_category?
    #return false unless self.errors.empty?
    return false if category.nil?
  end

  def is_admin_user?
    return false if user.nil?
    return false unless user.admin?
  end

  def can_not_update_user
    false if user_id_changed?
  end
end
