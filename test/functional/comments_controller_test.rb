require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  setup do
    @comment = comments(:one)
    session[:user_id] = 1 #set as logged-in
    session[:user_admin] = true #set as admin
    session[:user_name] = 'meng' #requires an admin user to be logged in
    @request.env['HTTP_REFERER'] = 'http://test.host/comments' #for :back redirect
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:comments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create comment" do
    assert_difference('Comment.count') do
      post :create, comment: {body: @comment.body, commentable_id: @comment.commentable_id, commentable_type: @comment.commentable_type, param: {comment: 1} }
    end

    assert_redirected_to comment_path(assigns(:comment))
  end

  test "should show comment" do
    get :show, id: @comment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @comment
    assert_response :success
  end

  test "should update comment" do
    put :update, id: @comment, comment: { body: @comment.body, commentable_id: @comment.commentable_id, commentable_type: @comment.commentable_type }
    assert_redirected_to comment_path(assigns(:comment))
  end

  test "should destroy comment" do
    assert_difference('Comment.count', -1) do
      delete :destroy, id: @comment
    end

    assert_redirected_to comments_path
  end
end
