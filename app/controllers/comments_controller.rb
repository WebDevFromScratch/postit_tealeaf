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
end