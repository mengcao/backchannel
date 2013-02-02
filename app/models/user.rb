class User < ActiveRecord::Base
  attr_accessible :name, :password
  validates :name, :uniqueness => true
end
