require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'votable_id is accessible' do
    v = Vote.new
    v.votable_id = 1 #if no error, this works
    assert true
  end

  test 'votable_type is accessible' do
    v = Vote.new
    v.votable_type = 'Post' #if no error, this works
    assert true
  end

  test 'user_id is accessible' do
    v = Vote.new
    v.user_id = 1 #if no error, this works
    assert true
  end

  test 'can access update_post' do
    v = Vote.new
    assert_respond_to(v, :update_post, 'Should be able to access update_post')
  end

  test 'can access post' do
    v = Vote.new
    assert_respond_to(v, :post, 'Should be able to access post')
  end

end
