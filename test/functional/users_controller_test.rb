require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:meng)
    session[:user_id] = @user.id
    session[:admin] = @user.admin
    session[:user_name] = @user.name
    request.env["HTTP_REFERER"] = "back"
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: { name: 'mike', password: 'mike', password_confirmation: 'mike' }
    end

    assert_redirected_to :root
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    put :update, id: @user, user: { name: @user.name, password: @user.password, password_confirmation: @user.password }
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end
    assert_redirected_to users_path
  end

  test "login with valid credential" do
    get :login, :login => {:name => @user.name,:password => @user.password}
    assert_equal @user.id,session[:user_id]
    assert_equal @user.name,session[:user_name]
    assert_equal @user.admin,session[:user_admin]
    assert_redirected_to "back"
  end

  test "login with invalid credential" do

    get :login,:login => {:name => @user.name,:password => "wrong_password"}
    assert_equal "Wrong user name or wrong password!",flash[:notice]
    assert_redirected_to "back"
  end

  test "log out" do
    get :logout
    assert_equal nil,session[:user_id]
    assert_equal nil,session[:user_name]
    assert_equal nil,session[:user_admin]
    assert_redirected_to :root
  end
end
