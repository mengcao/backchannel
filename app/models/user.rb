class User < ActiveRecord::Base
  attr_accessible :name, :password,:admin
  validates :name, :uniqueness => true
end
