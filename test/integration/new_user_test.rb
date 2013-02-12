require 'test_helper'

class NewUserTest < ActionDispatch::IntegrationTest
  fixtures :all
  # test "the truth" do
  #   assert true
  # end

  setup do
    @post = posts(:post_one)
    @name = 'name'
    @password = 'password'
  end

  test 'new user' do
    # try to create post without being a user or logged in
    get new_post_path
    assert_equal "Please login first. " ,flash[:notice]
    assert_redirected_to '/'

    # try to create comment without being a user or logged in
    get new_post_comment_path(@post)
    assert_equal "Please login first. " ,flash[:notice]
    assert_redirected_to '/'

    # search without being a user or logged in
    get posts_path,:search => {:content => 'one',:user_id => '',:category_id => ''}
    assert_response :success

    #register as new user
    get '/users/new'
    assert_response :success

    #enter new user information
    post '/users',{:new => {:name => @name,:password => @password, :password_confirmation => @password}}
    assert_equal 'User was successfully created.  Please login when ready.',flash[:notice]

    #check new user can log in

    #check new user can log out

  end

end
