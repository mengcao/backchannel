class ApplicationController < ActionController::Base
  protect_from_forgery
  #before_filter :login?
  def login?
    if session[:user_id] == nil
      redirect_to 'users/login'
    end
  end
end
