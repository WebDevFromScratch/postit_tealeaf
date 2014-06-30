class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :require_no_user, only: [:new, :create]

  def new
    @user = User.new
  end


  def create
    #binding.pry
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
    #TODO: figure a way to elegantly change password, when:
    # - first, confirm the original password
    # - then, set new password

    if @user.update(user_params)
      unless params[:old_password] == ""
        if @user.authenticate(params[:old_password])
          @user.password = params[:user][:password]
          @user.save
        else
          flash.now[:error] = 
              "Current password doesn't match!"
          render :edit and return
        end
      end

      flash[:notice] = "Your profile was updated!"
      redirect_to root_path #change later to 'user_path' (when I create that)
    else
      render :edit
    end
  end

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

  def set_user
    @user = User.find(params[:id])
  end
end