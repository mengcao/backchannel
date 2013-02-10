module VotablesHelper
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

  def voters
    @voters = []
    self.votes.each do |v|
      @voters << v.user
    end
    return @voters
  end
end