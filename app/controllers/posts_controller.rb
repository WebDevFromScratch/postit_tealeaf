class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update]

  def index
    @posts = Post.all
  end

  def show; end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = User.first #hardcoded from the solution vid, TBD later, once we have authentication implemented

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

  private

  def post_params
    params.require(:post).permit(:title, :url, :description, :user) #could change to .permit! if permitting all
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
