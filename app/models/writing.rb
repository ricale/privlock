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
#

class Writing < ActiveRecord::Base
  belongs_to :category

  validates :title,
            :content,
            :category_id,
            presence: true

  before_save :is_exist_category?

  scope :in_categories, ->(category_ids) { where("category_id in (?)", category_ids) }

  scope :in_category_tree, ->(category_id) {
    where("category_id in (?)", Category.hierarchy_categories(category_id).map { |c| c.id } << category_id)
  }


  private 

  def is_exist_category?
    #return false unless self.errors.empty?
    return false if Category.find_by(id: category_id).nil?
  end
end
