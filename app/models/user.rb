class User < ActiveRecord::Base
  attr_accessible :name, :password,:admin,:password_confirmation
  validates :name, :uniqueness => true,:presence => true
  validates :password, :confirmation => true,:presence => true
  validates :password_confirmation,:presence => true
end
