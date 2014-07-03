class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :require_no_user, only: [:new, :create]
  before_action :require_user, only: [:show, :edit, :create]

  def new
    @user = User.new
  end


  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id #logging in on register

      flash[:notice] = "You have registered!"
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    @user.username = params[:user][:username]
    @user.old_password = params[:old_password]

    if @user.update(user_params) 
      flash[:notice] = "Your profile was successfully updated."
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end 

  #  record = User.find(params[:id])
  #  value = params[:user][:password]

  #  binding.pry

  #  if @user.update(user_params) #don't know why I had '.save' here earlier    
  #    flash[:notice] = "Your profile was updated!"
  #    redirect_to user_path(@user.id)
  #  else
  #    render :edit
  #  end

  #this is not working as of yet! (no template for all users)
  def index
    @users = User.all
  end

  def show
    @posts = @user.posts.all
  end

  private

  def user_params
    params.require(:user).permit!
  end

  def user_params_with_new_password
    params.require(:user, :new_password).permit!
  end

  def set_user
    @user = User.find(params[:id])
  end
end