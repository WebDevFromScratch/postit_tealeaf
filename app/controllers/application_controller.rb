class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?, :user_voted?, :require_creator,
                :require_admin, :vote_for_show

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

  def access_denied
    flash[:error] = "You are not allowed to do that!"
    redirect_to root_path
  end

  def vote_for_show(obj)
    vote = obj.votes.find_by(user_id: current_user.id).vote
    if vote == true
      vote_print = "up!"
    elsif vote == false
      vote_print = "down!"
    else
      vote_print = "none"
    end
    vote_print
  end

  def vote_for_js

  end
end
