class Category < ActiveRecord::Base
  has_many :writing, dependent: :restrict
end