class CategoriesController < ApplicationController
  def new
    @category = Category.new
  end

  def create
    @category = Category.new(params.require(:category).permit(:name))
    if @category.save
      flash[:notice] = "#{@category.name} category was created!"
      redirect_to :posts #or '/posts'
    else
      render :new
    end
  end
end