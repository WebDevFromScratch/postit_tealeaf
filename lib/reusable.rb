module Reusable
  #here I keep re-usable methods for my models; inlude wherever needed

  def total_votes
    upvotes - downvotes
  end

  def upvotes
    votes.where(vote: true).size
  end

  def downvotes
    votes.where(vote: false).size
  end
end