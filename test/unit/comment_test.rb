require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "count votes" do
    @comment = comments(:comment_one)
    assert_equal 4,@comment.count_comments
  end
end
