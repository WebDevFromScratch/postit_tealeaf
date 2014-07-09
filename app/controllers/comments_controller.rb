class CommentsController < ApplicationController
  before_action :require_user

  def create
    @post = Post.find_by(slug: params[:post_id])
    @comment = Comment.new(params.require(:comment).permit(:body))
    @comment.user = current_user
    @comment.post_id = @post.id

    if @comment.save
      flash[:notice] = "Your comment was added!"
      redirect_to post_path(@post)
    else
      render "posts/show"
    end
  end

  def vote
    binding.pry
    @post = Post.find_by(slug: params[:post_id])

    @comment = Comment.find(params[:id])
    @vote = Vote.create(voteable: @comment, user: current_user, vote: params[:vote])

    respond_to do |format|
      format.html do
        if @vote.valid?
          flash[:notice] = "Your vote was counted"
        else
          flash[:error] = "You can only vote on that once"
        end

        redirect_to :back
      end
      format.js { render "posts/comment_vote" }
    end
  end

  def vote_change
    @comments = Comment.all
    @comment = Comment.find(params[:id])
    @vote = @comment.votes.find_by user_id: current_user.id
    @vote.old_vote = @vote[:vote]
    @vote.new_vote = params[:vote]

    respond_to do |format|
      format.html do
        if @vote.valid?
          @vote.update(vote: params[:vote])
          flash[:notice] = "Your vote was changed"
        else
          flash[:error] = "You only have one vote (up or down)"
        end
        redirect_to :back
      end
      format.js do
        if @vote.valid?
          @vote.update(vote: params[:vote])
        end
        render "posts/comment_vote_change"
      end
    end
  end
end