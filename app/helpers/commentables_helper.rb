module CommentablesHelper
  def count_comments
    @count = 0
    @comments = self.comments
    @count = @count + @comments.count
    if @comments.count > 0
      @comments.each do |c|
        @count += c.count_comments
      end
    end
    return @count
  end
end