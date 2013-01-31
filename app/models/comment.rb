class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable,:polymorphic => true
  has_many :comments,:as => :commentable,:dependent => :destroy
  has_many :votes, :as => :votable,:dependent => :destroy
  attr_accessible :body, :commentable_id, :commentable_type,:user_id

  def post
    return @post if defined?(@post)
    @post = commentable.is_a?(Post) ? commentable : commentable.post
  end
end
