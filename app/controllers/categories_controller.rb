class CategoriesController < ApplicationController
  before_action :require_user, except: [:show]

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(params.require(:category).permit(:name))
    if @category.save
      flash[:notice] = "#{@category.name} category was created!"
      redirect_to root_path #which is :posts (or '/posts') in our case
    else
      render :new
    end
  end

  def show
    @category = Category.find(params[:id])
  end
end