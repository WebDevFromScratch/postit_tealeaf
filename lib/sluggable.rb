module Sluggable
  extend ActiveSupport::Concern

  included do
    attr_accessor :column
    #if self.is_a?(Post)
    #  before_create :generate_slug
    #else
      before_save :generate_slug
    #end
  end

  def generate_slug
    set_column
    self.slug = self.column.downcase.gsub(' ', '-').gsub(/[.,!?]/, '')
  end

  def set_column
    if self.instance_of?(Post)
      self.column = self.title
    elsif self.instance_of?(Category)
      self.column = self.name
    elsif self.instance_of?(User)
      self.column = self.username
    end
  end
    
  def to_param
    self.slug
  end
end