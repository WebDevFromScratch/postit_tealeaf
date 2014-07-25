class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :vote, :vote_change]
  before_action :require_user, except: [:index, :show]
  before_action :require_creator_or_admin, only: [:edit ,:update]

  def index
    @posts = Post.all
  end

  def show
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user

    if @post.save
      flash[:notice] = "Your post was created!"
      redirect_to posts_path
    else
      render :new #this could also be written using symbol 'new'
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      flash[:notice] = "Your post was edited!"
      redirect_to post_path(@post)
    else
      render :edit #or 'edit'
    end
  end

  def vote
    @vote = Vote.create(voteable: @post, user: current_user, vote: params[:vote])
    #@vote.user = current_user
    #@vote.voteable = @post

    respond_to do |format| #this is AJAX
      format.html do
        if @vote.valid?
          flash[:notice] = "Your vote was counted"
        else
          flash[:error] = "You can only vote on a post once"
        end

        redirect_to :back
      end
      format.js {} #nothing's here, default action in Rails is render
                  # ---> thus this will try to render a vote.js.erb template
    end
  end

  def vote_change
    @vote = @post.votes.find_by user_id: current_user.id
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
      end
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :url, :description, :user, category_ids: []) #could change to .permit! if permitting all
  end

  def set_post
    #@post = Post.find_by params[:slug]
    @post = Post.find_by(slug: params[:id])
  end

  def user_is_creator?
    current_user == @post.user
  end

  def require_creator
    access_denied unless logged_in? && user_is_creator?
  end

  def require_creator_or_admin
    access_denied unless logged_in? && (user_is_creator? || current_user.is_admin?)
  end
end
