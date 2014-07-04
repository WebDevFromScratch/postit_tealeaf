class CommentsController < ApplicationController
  before_action :require_user

  def create
    @post = Post.find(params[:post_id])
    @comment = Comment.new(params.require(:comment).permit(:body))
    @comment.user = current_user
    @comment.post_id = params[:post_id]

    if @comment.save
      flash[:notice] = "Your comment was added!"
      redirect_to post_path(@post)
    else
      render "posts/show"
    end
  end

  def vote
    @vote = Vote.new(vote: params[:vote])
    @vote.user = current_user
    @vote.voteable = Comment.find(params[:id])

    if @vote.save
      flash[:notice] = "Your vote was counted"
      redirect_to :back
    else
      flash[:error] = "You can only vote on that once"
      render :index
    end
  end
end