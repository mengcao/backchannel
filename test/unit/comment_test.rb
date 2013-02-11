require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  setup do
    @myComment = Comment.new
    @myComment.comments = [Comment.new, Comment.new, Comment.new]
    @myComment.votes = [Vote.new, Vote.new, Vote.new, Vote.new]
  end

  test 'has many comment' do
    assert_equal(3, @myComment.comments.size)
  end

  test 'has many votes' do
    assert_equal(4, @myComment.votes.size)
  end

  test 'should require body and presence fields' do
    c = Comment.new
    assert(!(c.valid?), 'Should be false')
  end

  test 'body is accessible' do
    c = Comment.new
    c.body = 'body' #if no error, this works
    assert true
  end

  test 'commentable_id is accessible' do
    c = Comment.new
    c.commentable_id = 1 #if no error, this works
    assert true
  end

  test 'commentable_type is accessible' do
    c = Comment.new
    c.commentable_type = 'Post' #if no error, this works
    assert true
  end

  test 'user_id is accessible' do
    c = Comment.new
    c.user_id = 1 #if no error, this works
    assert true
  end

  test 'should have necessary requires' do
    c = Comment.new
    c.body = 'body'
    assert(c.valid?, 'Should be true')
  end

  test 'can access count_vote' do
    c = Comment.new
    assert_respond_to(c, :count_vote, 'Should be able to access count_vote')
  end

  test 'can access voters' do
    c = Comment.new
    assert_respond_to(c, :voters, 'Should be able to access voters')
  end

  test "count votes" do
    @comment = comments(:comment_one)
    assert_equal 4,@comment.count_comments
  end
end
