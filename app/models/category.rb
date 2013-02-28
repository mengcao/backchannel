class Category < ActiveRecord::Base
  has_many :posts,:dependent => :destroy
  validates :name,:presence => :true
  attr_accessible :name
end
