require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  setup do
    @comment = comments(:comment_one)
    @post = posts(:post_one)
    @admin = users(:meng)
    session[:user_id] = @admin.id
    session[:user_admin] = @admin.admin
    session[:user_name] = @admin.name
    request.env["HTTP_REFERER"] = "back" #for :back redirect
  end

  test 'new comment on a post' do
    get :new,:post_id => @post.id
    assert_response :success
  end

  test 'new comment on a comment' do
    get :new,:comment_id => @comment.id
    assert_response :success
  end

  test "create comment on a post" do
    assert_difference('@post.comments.count',+1) do
      post :create, comment: {body: 'comment'},:post_id => @post.id
    end
    assert_redirected_to post_path(@post)
  end

  test "create comment on a comment" do
    assert_difference('@comment.comments.count',+1) do
      post :create, comment: {body: 'comment on a comment'},:comment_id => @comment.id
    end
    assert_redirected_to post_path(@comment.post)
  end

  test "edit comment" do
    get :edit, id: @comment
    assert_response :success
  end

  test "should update comment" do
    put :update, id: @comment, comment: { body: @comment.body, commentable_id: @comment.commentable_id, commentable_type: @comment.commentable_type }
    assert_redirected_to post_path(@comment.post)
  end

  test "should destroy comment" do
    assert_difference('Comment.count', -(1 + @comment.count_comments)) do
      delete :destroy, id: @comment
    end
    assert_redirected_to post_path(@comment.post)
  end
end
