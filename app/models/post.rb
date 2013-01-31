class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments,:as => :commentable,:dependent => :destroy
  has_many :votes,:as => :votable,:dependent => :destroy
  attr_accessible :body, :title,:user_id
end
