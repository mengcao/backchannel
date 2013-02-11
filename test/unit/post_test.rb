require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  setup do
    @myPost = Post.new
    @myPost.comments = [Comment.new, Comment.new, Comment.new, Comment.new, Comment.new]
    @myPost.votes = [Vote.new, Vote.new, Vote.new]
  end

  test 'has many comments' do
    assert_equal(5, @myPost.comments.size)
  end

  test 'has many votes' do
    assert_equal(3, @myPost.votes.size)
  end

  test 'should require body and title' do
    p = Post.new
    assert(!(p.valid?), 'Should be false')
  end

  test 'body is accessible' do
    p = Post.new
    p.body = 'body' #if no error, this works
    assert true
  end

  test 'title is accessible' do
    p = Post.new
    p.title = 'title' #if no error, this works
    assert true
  end

  test 'user_id is accessible' do
    p = Post.new
    p.user_id = 1
    assert true
  end

  test 'category_id is accessible' do
    p = Post.new
    p.category_id = 1
    assert true
  end

  test 'can access count_votes' do
    c = Comment.new
    assert_respond_to(c, :count_votes, 'Should be able to access count_vote')
  end

  test 'can access voters' do
    c = Comment.new
    assert_respond_to(c, :voters, 'Should be able to access voters')
  end
end
