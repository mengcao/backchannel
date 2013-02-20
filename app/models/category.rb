class Category < ActiveRecord::Base
  has_many :posts,:dependent => :destroy
  attr_accessible :name
end
