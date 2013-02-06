class User < ActiveRecord::Base
  attr_accessible :name, :password,:admin
  validates :name, :uniqueness => true

  def login?
    return session[:user_id]
  end
end
