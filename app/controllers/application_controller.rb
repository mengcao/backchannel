class ApplicationController < ActionController::Base
  protect_from_forgery

  def login?
    if (session[:user_id] == nil)
      flash[:notice] = 'Please login first. '
      redirect_to :root
    end
  end

  def admin?
    if (session[:user_admin] == false)
      flash[:notice] = 'You do not have the access to this page.'
      redirect_to :root
    end
  end

  def empty_category?
    if Category.count == 0
      flash[:notice] = 'Create at lease one category before posting.'
      redirect_to :back
    end
  end
end
