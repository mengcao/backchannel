require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  setup do
    @myCategory = Category.new
    @myCategory.posts = [Post.new, Post.new, Post.new]
  end

  test 'name is accessible' do
    c = Category.new
    c.name = 'c' #if no error, this works
    assert true
  end

  test 'has many posts' do
    assert_equal(3, @myCategory.posts.size)
  end

end
