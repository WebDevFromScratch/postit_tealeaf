class Category < ActiveRecord::Base
  before_save :generate_slug

  has_many :post_categories
  has_many :posts, through: :post_categories

  def category_name
    name
  end

  validates :name, presence: true

  def generate_slug
    self.slug = self.name.downcase.gsub(' ', '-').gsub(/[.,!?]/, '')
  end

  def to_param
    self.slug
  end
end