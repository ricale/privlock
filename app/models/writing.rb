class Writing < ActiveRecord::Base
  validates :title, :content, presence: true
end
