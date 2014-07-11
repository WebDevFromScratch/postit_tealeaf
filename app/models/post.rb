class Post < ActiveRecord::Base
  include Voteable #this module is in /lib folder

  before_create :generate_slug

  belongs_to :user
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories
  has_many :votes, as: :voteable

  validates :title, presence: true, length: {minimum: 5}
  validates :description, presence: true
  validates :url, presence: true, uniqueness: true

  def generate_slug
    self.slug = self.title.downcase.gsub(' ', '-').gsub(/[.,!?]/, '')
  end

  def to_param
    self.slug
  end
end