class Vote < ActiveRecord::Base

  attr_accessor :old_vote, :new_vote

  belongs_to :user
  belongs_to :voteable, polymorphic: true

  validates_uniqueness_of :user, scope: [:voteable_id, :voteable_type]
  #validates_uniqueness_of :user, scope: :voteable - this syntax is not supported
                                                    #anymore
  validate :can_change_vote?, on: :update

  def can_change_vote?
    if self.old_vote == to_boolean(self.new_vote)
      errors.add(:base, "You only have one vote (up or down)")
    end
  end

  def to_boolean(str)
    str == "true"
  end
end