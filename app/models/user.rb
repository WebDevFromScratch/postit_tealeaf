require 'bcrypt' #try to remove these bcrypt things later and see if it works

class User < ActiveRecord::Base
  include BCrypt

  attr_accessor :old_password

  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 8 }, on: :create

  validate :current_password_errors
  validates :password, presence: true, length: { minimum: 8 }, on: :update,
            if: :current_password_match?

  def current_password
    BCrypt::Password.new(User.find(self.id).password_digest)
  end

  def current_password_match?
    current_password == self.old_password unless self.old_password.blank?
  end

  def current_password_errors
    if self.old_password.blank? && !self.password.blank?
      errors.add(:base, "You must enter your current password to set a new one")
    elsif !current_password_match? #current_password != self.old_password
      errors.add(:base, "Old password doesn't match") unless self.old_password.blank?
    end
  end
end