require 'test_helper'

class UserFlowsTest < ActionDispatch::IntegrationTest
  fixtures :all
  # test "the truth" do
  #   assert true
  # end

  setup do
    @kenny = users(:kenny)
    @admin = users(:meng)
    @category = categories(:category_one)
    @referer = "back"
    @post = posts(:post_one)
    @kennys_post = posts(:post_two)
    @comment = comments(:comment_one)
    @kennys_comment = comments(:comment_three)
    @vote = votes(:vote_one)
  end
  test "registered user" do
    # login
    post '/users/login',{:login => {:name => @kenny.name,:password=> @kenny.password}},{'HTTP_REFERER' => '/posts'}
    assert_redirected_to '/posts'

    # can search
    get posts_path,:search => {:content => 'one',:user_id => '',:category_id => ''}
    assert_response :success

    # create a new post
    get '/posts/new'
    assert_response :success

    post '/posts',{:post => {:title => 'create post',:body => 'create post',:category_id => @category.id,:user_id => @kenny.id}}
    assert_redirected_to post_path(assigns(:post))

    # comment on a post
    get new_post_comment_path(@post)
    assert_response :success

    post post_comments_path(@post),{:comment => {:body => 'create comment on a post'},:post_id => @post.id}
    assert_redirected_to post_path(@post)

    # comment on a comment
    get new_comment_comment_path(@comment)
    assert_response :success

    post comment_comments_path(@comment),{:comment => {:body => 'create comment on a comment'},:comment_id => @comment.id}
    assert_redirected_to post_path(@comment.post)

    # edit one's own post
    get edit_post_path(@kennys_post)
    assert_response :success

    put post_path(@kennys_post),{:post => {:body => 'update post'}}
    assert_redirected_to post_path(assigns(:post))

    # delete one's own post
    delete post_path(@kennys_post)
    assert_redirected_to posts_path

    # edit others post
    get edit_post_path(@post)
    assert_equal 'You are not the owner of this post.',flash[:notice]
    assert_redirected_to post_path(@post)

    # edit one's own comment
    get edit_comment_path(@kennys_comment)
    assert_response :success

    put comment_path(@kennys_comment),{:comment => {:body => 'update comment'}}
    assert_redirected_to post_path(@kennys_comment.post)

    # delete one's own comment
    delete comment_path(@kennys_comment)
    assert_redirected_to post_path(@kennys_comment.post)

    # edit others comment
    get edit_comment_path(@comment)
    assert_equal 'You are not the owner of this comment.',flash[:notice]
    assert_redirected_to post_path(@comment.post)

    # vote for a post
    post post_votes_path(@post), {:post_id => @post.id},{"HTTP_REFERER" => post_path(@post)}
    assert_redirected_to post_path(@post)

    # vote for a comment
    post comment_votes_path(@comment),{:comment_id => @comment.id},{"HTTP_REFERER" => post_path(@comment.post)}
    assert_redirected_to post_path(@comment.post)

    # un-vote a post
    delete vote_path(@vote),{},{"HTTP_REFERER" => post_path(@post)}
    assert_redirected_to post_path(@post)

    # logout
    get '/users/logout'
    assert_redirected_to '/'

    # try to create post when logged out
    get new_post_path
    assert_equal "Please login first. " ,flash[:notice]
    assert_redirected_to '/'

    # try to create comment when logged out
    get new_post_comment_path(@post)
    assert_equal "Please login first. " ,flash[:notice]
    assert_redirected_to '/'

    # still can search
    get posts_path,:search => {:content => 'one',:user_id => '',:category_id => ''}
    assert_response :success

  end
end
