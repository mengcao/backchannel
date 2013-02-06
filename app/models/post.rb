class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  has_many :comments,:as => :commentable,:dependent => :destroy
  has_many :votes,:as => :votable,:dependent => :destroy
  attr_accessible :body, :title,:user_id,:category_id
  validates :title,:presence => true
  validates :body,:presence => true

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
end
