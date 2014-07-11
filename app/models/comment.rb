class Comment < ActiveRecord::Base
  include Voteable #this module is in /lib folder

  belongs_to :user
  belongs_to :post

  validates :body, presence: true
end