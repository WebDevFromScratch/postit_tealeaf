class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :require_user, except: [:index, :show]

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

  def edit; end

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

    if !@vote.errors.any?
      flash[:notice] = "Your vote was counted"
    else
      flash[:error] = "You can only vote on that once"
    end

    redirect_to :back

    #!!!note that there's a different flow here; study this in a spare while
  end

  private

  def post_params
    params.require(:post).permit(:title, :url, :description, :user, category_ids: []) #could change to .permit! if permitting all
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
