class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, :polymorphic => true
  attr_accessible :votable_id, :votable_type,:user_id

  def update_post
    @post = self.post
    @post.updated_at = self.created_at
    @post.save
  end

  def post
    return @post if defined?(@post)
    @post = self.votable.is_a?(Post) ? self.votable : self.votable.post
  end
end