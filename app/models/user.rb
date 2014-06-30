class User < ActiveRecord::Base
  has_many :posts
  has_many :comments

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 8 }, on: :create

  #validate :password_validation_with_old_password, on: :update

  private

  #def password_validation_with_old_password
  #  if @user.authenticate("ramm")
  #    validates :password, presence: true, length: { minimum: 8 }
  #  end
  #end
end