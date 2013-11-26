class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  after_validation :first_user_is_admin

  before_destroy :never_destroy_admin_user

  private

  def first_user_is_admin
    self.admin = true if User.count == 0
  end

  def never_destroy_admin_user
    false if admin
  end
end
