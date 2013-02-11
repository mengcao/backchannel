module VotablesHelper
  attr_accessor :show_voters
  def count_votes (user_id)
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

  def voters(user_id)
    @voters = []
    self.votes.each do |v|
      if v.user.id != user_id
        @voters << v.user
      end
    end
    return @voters
  end
end