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
    @results = self.find(:all)
    if criteria
      if criteria[:content] != ''
        @comment_results = Comment.where('body like ?',"%#{criteria[:content]}%")
        @results.select! {|r| r.body.downcase.include?(criteria[:content].downcase) || r.title.downcase.include?(criteria[:content].downcase)}
        @comment_results.each do |r|
          p = r.post
          if !@results.include?(p)
            @results << p
          end
        end
      end
      if criteria[:user_id] != ''
        @results.select! {|r| r.user_id == criteria[:user_id].to_i}
      end
      if criteria[:category_id] != ''
        @results.select! {|r| r.category_id == criteria[:category_id].to_i}
      end
    end
    @results.sort!  {|x,y| y.updated_at <=> x.updated_at}
    return @results
  end
end
