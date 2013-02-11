class Comment < ActiveRecord::Base
  include VotablesHelper
  include CommentablesHelper
  belongs_to :user
  belongs_to :commentable,:polymorphic => true
  has_many :comments,:as => :commentable,:dependent => :destroy
  has_many :votes, :as => :votable,:dependent => :destroy
  attr_accessible :body, :commentable_id, :commentable_type,:user_id
  validates :body,:presence => true

  def post
    return @post if defined?(@post)
    @post = self.commentable.is_a?(Post) ? self.commentable : self.commentable.post
  end

  def update_post
    @post = self.post
    @post.updated_at=self.updated_at
    @post.save
  end
end
