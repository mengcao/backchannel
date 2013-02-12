class ApplicationController < ActionController::Base
  protect_from_forgery
  # before_filter :login?

  def login?
    if (session[:user_id] == nil)
      flash[:notice] = 'Please login first. '
      redirect_to :root
    end
  end

  def admin?
    if (session[:user_admin] == false)
      redirect_to :root
    end
  end
end
