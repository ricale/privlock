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
  before_validation :is_valid_writer?

  before_validation :can_update_content_only, on: :update

  before_save :is_exist_writing?

  def password
    if password_hash.nil?
      nil

    else
      @password ||= Password.new(password_hash)
    end
  end

  def password=(new_password)
    if new_password.nil? || new_password.blank?
      self.password_hash = nil

    else
      @password = Password.create(new_password)
      self.password_hash = @password
    end
  end

  def display_name
    user.nil? ? name : user.name
  end


  def self.last_updated_at(writing_id)
    Comment.where(writing_id: writing_id).maximum(:updated_at)
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
    if !is_valid_email?
      errors[:email] << "is invalid."
      return false
    end

    if name.nil? || name.blank?
      errors[:name] << "can't be blank."
      return false
    end

    if password.nil?
      errors[:password] << "can't be blank."
      return false
    end

    true
  end

  def is_valid_email?
    !email.nil? && !email.blank? && email.match(/[a-z\.-_0-9]+@[a-z\.-_0-9]+/).nil? ? false : true
  end

  def can_update_content_only
    return false if writing_id_changed?
    return false if email_changed?
    return false if name_changed?
    return false if password_hash_changed?
    return false if user_id_changed?
  end
end
