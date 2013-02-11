require 'test_helper'

class VotesControllerTest < ActionController::TestCase
  setup do
    @vote = votes(:vote_one)
    @post = posts(:post_one)
    @comment = comments(:comment_one)
  end

  test "vote for a post" do
    request.env["HTTP_REFERER"] = "back"
    assert_difference('@post.votes.count',+1 ) do
      post :create, :post_id => @post.id
    end
    assert_redirected_to "back"
  end

  test "vote for a comment" do
    request.env["HTTP_REFERER"] = "back"
    assert_difference('@comment.votes.count',+1) do
      post :create, :comment_id => @comment.id
    end
    assert_redirected_to "back"
  end

  test "unvote" do
    request.env["HTTP_REFERER"] = "back"
    if @vote.votable_type == "Post"
      @votable = Post.find_by_id(@vote.votable_id)
    else
      @votable = Comment.find_by_id(@vote.votable_id)
    end
    assert_difference('@votable.votes.count',-1) do
      delete :destroy, :id => @vote
    end
  end
end
