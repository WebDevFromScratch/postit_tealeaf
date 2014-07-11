#Rails way (using concerns)
module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :voteable
  end
  
  def total_votes
    up_votes - down_votes
  end

  def up_votes
    votes.where(vote: true).size
  end

  def down_votes
    votes.where(vote: false).size
  end
end

#standard metaprogramming way, it's doing exactly the same as the code above
=begin
module Voteable
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.extend ClassMethods
    base.class_eval do
      has_votes
    end
  end

  module InstanceMethods
    def total_votes
      up_votes - down_votes
    end

    def up_votes
      votes.where(vote: true).size
    end

    def down_votes
      votes.where(vote: false).size
    end
  end

  module ClassMethods
    def has_votes
      has_many :votes, as: :voteable
    end
  end
end
=end