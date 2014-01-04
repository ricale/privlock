# == Schema Information
#
# Table name: comments
#
#  id            :integer          not null, primary key
#  writing_id    :integer          not null
#  email         :string(255)
#  name          :string(255)
#  password_hash :string(255)
#  user_id       :integer
#  content       :text             not null
#  created_at    :datetime
#  updated_at    :datetime
#

class Comment < ActiveRecord::Base
  include BCrypt

  attr_accessor :password

  belongs_to :writing
  belongs_to :user

  validates :writing_id,
            :content,
            presence: true

  before_validation :default_values

  before_validation :can_update_content_only, on: :update

  before_save :is_exist_writing?
  before_save :is_valid_writer?

  def password
    if password_hash.nil?
      nil

    else
      @password ||= Password.new(password_hash)
    end
  end

  def password=(new_password)
    if new_password.nil?
      self.password_hash = nil

    else
      @password = Password.create(new_password)
      self.password_hash = @password
    end
  end


  private

  def default_values
  end

  def is_exist_writing?
    false if writing.nil?
  end

  def is_valid_writer?
    if user_id.nil?
      is_valid_visitor?
    else  
      is_valid_user? || is_valid_visitor?
    end
  end

  def is_valid_user?
    user.nil? ? false : true
  end

  def is_valid_visitor?
    !is_valid_email? || name.nil? || password.nil? ? false : true
  end

  def is_valid_email?
    email.nil? || email.match(/[a-z\.-_0-9]+@[a-z\.-_0-9]+/).nil? ? false : true
  end

  def can_update_content_only
    return false if writing_id_changed?
    return false if email_changed?
    return false if name_changed?
    return false if password_hash_changed?
    return false if user_id_changed?
  end
end
