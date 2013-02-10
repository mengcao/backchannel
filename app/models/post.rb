class Post < ActiveRecord::Base
  include VotablesHelper
  belongs_to :user
  belongs_to :category
  has_many :comments,:as => :commentable,:dependent => :destroy
  has_many :votes,:as => :votable,:dependent => :destroy
  attr_accessible :body, :title,:user_id,:category_id
  validates :title,:presence => true
  validates :body,:presence => true
  def self.search(criteria)
    @results = self.order('updated_at DESC')
    if criteria
      if criteria[:content] != ''
        @comment_results = Comment.where('body like ?',"%#{criteria[:content]}%")
        @results = @results.where('body like ? OR title like ?', "%#{criteria[:content]}%","%#{criteria[:content]}%")
        @comment_results.each do |r|
          p = r.post
          if !@results.include?(p)
            @results << p
          end
        end
      end
      if criteria[:user_id] != ''
        @results = @results.where(:user_id => criteria[:user_id])
      end
      if criteria[:category_id] != ''
        @results = @results.where(:category_id => criteria[:category_id])
      end
    end
    return @results.where(nil)
  end
end
