require 'test_helper'

class AdminFlowsTest < ActionDispatch::IntegrationTest
  fixtures :all
  # test "the truth" do
  #   assert true
  # end

  setup do
    @meng = users(:meng) #meng is an admin
    @csc = users(:csc)
    @category = categories(:category_one)
    @referer = "back"
    @post = posts(:post_one)
    @kennys_post = posts(:post_two)
    @comment = comments(:comment_one)
    @kennys_comment = comments(:comment_two)
    @vote = votes(:vote_two)
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

    # edit one's own comment
    get edit_comment_path(@comment)
    assert_response :success

    put comment_path(@comment),{:comment => {:body => 'update comment'}}
    assert_redirected_to post_path(@comment.post)

    # edit other's post, which an admin can do
    get edit_post_path(@kennys_post)
    assert_response :success

    put post_path(@kennys_post), {:post => {:body => 'bite me if you can'}}
    assert_redirected_to post_path(@kennys_post)

    # edit other's comment, which an admin can do
    get edit_comment_path(@kennys_comment)
    assert_response :success

    put comment_path(@kennys_comment), {:comment => {:body => 'I am the overruler, I can shut you up!'}}
    assert_redirected_to post_path(@kennys_comment.post)

    # vote for a post
    post post_votes_path(@kennys_post), {:post_id => @kennys_post.id},{"HTTP_REFERER" => post_path(@kennys_post)}
    assert_redirected_to post_path(@kennys_post)

    # vote for a comment
    post comment_votes_path(@kennys_comment),{:comment_id => @kennys_comment.id},{"HTTP_REFERER" => post_path(@kennys_comment.post)}
    assert_redirected_to post_path(@kennys_comment.post)

    # un-vote a post
    delete vote_path(@vote),{},{"HTTP_REFERER" => post_path(@post)}
    assert_redirected_to post_path(@post)

    # delete one's own comment
    delete comment_path(@comment)
    assert_redirected_to post_path(@comment.post)

    # delete others comment which an admin can do
    delete comment_path(@kennys_comment)
    assert_redirected_to post_path(@kennys_comment.post)

    # delete one's own post
    delete post_path(@post)
    assert_redirected_to posts_path

    # delete others post, which an admin can do
    delete post_path(@kennys_post)
    assert_redirected_to posts_path

    # edit other users
    get edit_user_path(@csc)
    assert_response :success

    put user_path(@csc),:user => {:name => 'csc517',:password => 'csc517',:password_confirmation => 'csc517',:admin=> true}
    assert_redirected_to user_path(@csc)

    # delete other users
    assert_difference('User.count',-1) do
      delete user_path(@csc)
    end
    assert_redirected_to users_path
  end
end