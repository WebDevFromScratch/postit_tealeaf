require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt

  attr_accessor :old_password

  has_many :posts
  has_many :comments

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 8 }, on: :create

  validate :old_password_must_match
  validates :password, presence: true, length: { minimum: 8 }, on: :update,
            if: :password_match? #,allow_blank: true #- not sure this should even be here


  def old_password_must_match
    current_password = BCrypt::Password.new(User.find(self.id).password_digest)

    if self.old_password.blank? && !self.password.blank?
      errors.add(:base, "You must enter your current password to set a new one")
    elsif current_password != self.old_password
      errors.add(:base, "Old password doesn't match") unless self.old_password.blank?
    end
  end

  def password_match?
    current_password = BCrypt::Password.new(User.find(self.id).password_digest)

    (current_password == self.old_password) unless self.old_password.blank?
  end
end