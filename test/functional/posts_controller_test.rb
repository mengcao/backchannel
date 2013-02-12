require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  setup do
    @post = posts(:post_one)
    @admin = users(:meng)
    @user = users(:kenny)
    @category = categories(:category_one)
    session[:user_id] = @admin.id
    session[:user_admin] = @admin.admin
    session[:user_name] = @admin.name
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:posts)
    assert_equal 3,assigns(:posts).count
  end

  test "should get search results" do
    get :index,:search => {:content => 'one',:user_id => '',:category_id => ''}
    assert_response :success
    assert_not_nil assigns(:posts)
    assert_equal 2,assigns(:posts).count
    assert_equal true, assigns(:posts).include?(@post)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create post" do
    assert_difference('Post.count',+1) do
      post :create, post: { body: @post.body, title: @post.title, user_id: @user.id, category_id: @category.id }
    end

    assert_redirected_to post_path(assigns(:post))
  end

  test "should show post" do
    get :show, id: @post
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @post
    assert_response :success
  end

  test "should update post" do
    put :update, id: @post, post: { body: 'update', title: @post.title }
    assert_redirected_to post_path(assigns(:post))
  end

  test "should destroy post" do
    assert_difference('Post.count', -1) do
      delete :destroy, id: @post
    end

    assert_redirected_to posts_path
  end
end
