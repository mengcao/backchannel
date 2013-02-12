require 'test_helper'

class AdminFlowsTest < ActionDispatch::IntegrationTest
  fixtures :all
  # test "the truth" do
  #   assert true
  # end

  setup do
    @meng = users(:meng) #meng is an admin
    @category = categories(:category_one)
    @referer = "back"
    @post = posts(:post_one)
    @kennys_post = posts(:post_two)
    @comment = comments(:comment_one)
    @mengs_comment = comments(:comment_three)
    @vote = votes(:vote_one)
  end
  test "admin user" do
    # login
    post '/users/login',{:login => {:name => @meng.name,:password=> @meng.password}},{'HTTP_REFERER' => '/posts'}
    assert_redirected_to '/posts'

    # can search
    get posts_path,:search => {:content => 'one',:user_id => '',:category_id => ''}
    assert_response :success

    # create a new post
    get '/posts/new'
    assert_response :success

    post '/posts',{:post => {:title => 'create post',:body => 'create post',:category_id => @category.id,:user_id => @meng.id}}
    assert_redirected_to post_path(assigns(:post))

    # comment on a post
    get new_post_comment_path(@post)
    assert_response :success

    post post_comments_path(@post),{:comment => {:body => 'create comment on a post'},:post_id => @post.id}
    assert_redirected_to post_path(@post)

    # comment on a comment
    post comment_comments_path(@comment),{:comment => {:body => 'create comment on a comment'},:comment_id => @comment.id}
    assert_redirected_to post_path(@comment.post)

    # edit one's own post
    get edit_post_path(@post)
    assert_response :success

    put post_path(@post),{:post => {:body => 'update post'}}
    assert_redirected_to post_path(assigns(:post))

    # delete one's own post
    delete post_path(@post)
    assert_redirected_to posts_path

    # delete others post, which an admin can do
    delete post_path(@kennys_post)
    assert_redirected_to posts_path

    # edit one's own comment
    get edit_comment_path(@mengs_comment)
    assert_response :success

    put comment_path(@mengs_comment),{:comment => {:body => 'update comment'}}
    assert_redirected_to post_path(@mengs_comment.post)

    # delete one's own comment
    delete comment_path(@mengs_comment)
    assert_redirected_to post_path(@mengs_comment.post)

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
    assert_equal 'User was success',flash[:notice]
  end
end