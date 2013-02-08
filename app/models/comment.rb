class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable,:polymorphic => true
  has_many :comments,:as => :commentable,:dependent => :destroy
  has_many :votes, :as => :votable,:dependent => :destroy
  attr_accessible :body, :commentable_id, :commentable_type,:user_id
  validates :body,:presence => true

  def post
    return @post if defined?(@post)
    @post = commentable.is_a?(Post) ? commentable : commentable.post
  end

  def count_vote (user_id)
    @votes = self.votes
    @votes_count = Array.new(2)
    if @votes.where(:user_id => user_id).count != 0
      @votes_count[0] = 1
      @votes_count[1] = self.votes.count - 1
    else
      @votes_count[0] = 0
      @votes_count[1] = self.votes.count
    end

    return @votes_count
  end

  def update_post
    @post = self.post
    @post.updated_at=self.updated_at
    @post.save
  end
end
