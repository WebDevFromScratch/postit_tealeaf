class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?, :user_voted?, :require_creator,
                :require_admin

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_user
    unless logged_in?
      flash[:error] = "You must be logged in to do that!"
      redirect_to root_path
    end
  end

  def require_no_user
    if logged_in?
      flash[:error] = "You can't do this when logged in!"
      redirect_to root_path
    end
  end

  def user_voted?(obj)
    obj.votes.any? { |vote| vote[:user_id] == current_user.id }
  end

  def user_is_creator?
    @post = Post.find_by(slug: params[:id])
    current_user == @post.user
  end

  def require_creator
    access_denied unless logged_in? && user_is_creator?
  end

  def require_admin
    access_denied unless logged_in? && current_user.is_admin?
  end

  def require_creator_or_admin
    access_denied unless logged_in? && (user_is_creator? || current_user.is_admin?)
  end

  def access_denied
    flash[:error] = "You are not allowed to do that!"
    redirect_to :back
  end
end
