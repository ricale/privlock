class Writing < ActiveRecord::Base
  belongs_to :category

  validates :title,
            :content,
            :category_id,
            presence: true

  before_save :is_exist_category?

  private 

  def is_exist_category?
    return false unless self.errors.empty?

    false if Category.find_by(id: category_id).nil?
  end
end
