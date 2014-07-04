class Comment < ActiveRecord::Base
  include Reusable #this module is in /lib folder

  belongs_to :user
  belongs_to :post
  has_many :votes, as: :voteable

  validates :body, presence: true
end