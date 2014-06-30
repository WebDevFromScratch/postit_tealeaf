class UsersController < ApplicationController
  before_action :require_no_user

  def new
    @user = User.new
  end


  def create
    #binding.pry
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = "You have registered!"
      redirect_to root_path
    else
      render :new
    end
  end

  #this is not working as of yet! (no template for all users)
  def index
    @users = User.all
  end

  private

  def user_params
    params.require(:user).permit!
  end
end