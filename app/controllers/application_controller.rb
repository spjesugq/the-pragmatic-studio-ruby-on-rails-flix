class ApplicationController < ActionController::Base
private
  helper_method :current_user
  helper_method :current_user?
  helper_method :current_user_admin?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_user?(user)
    current_user == user
  end

  def current_user_admin?
    current_user && current_user.admin?
  end

  def require_signin
    unless current_user
      session[:intended_url] = request.url
      redirect_to new_session_url, alert: "Please sign in first!"
    end
  end

  def require_correct_user
    @user = User.find(params[:id])
    unless current_user == @user
      redirect_to root_url, status: :see_other unless current_user?(@user)
    end
  end

  def require_admin
    unless current_user_admin?
      redirect_to root_url, alert: "Unauthorized access!"
    end
  end
end