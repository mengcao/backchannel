class User < ActiveRecord::Base
  attr_accessible :name, :password,:admin,:password_confirmation
  has_many :posts,:dependent => :destroy
  has_many :comments,:dependent => :destroy
  has_many :votes,:dependent => :destroy
  validates :name, :uniqueness => true,:presence => true
  validates :password, :confirmation => true,:presence => true
  validates :password_confirmation,:presence => true
end
