require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'name is accessible' do
    u = User.new
    u.name = 'user' #if no error, this works
    assert true
  end

  test 'password should be accessible' do
    u = User.new
    u.password = "password" #if no error, this works
    assert true
  end

  test 'password_confirmation should be accessible' do
    u = User.new
    u.password_confirmation = 'confirmation' #if no error, this works
    assert true
  end

  test 'admin should be accessible' do
    u = User.new
    u.admin = false #if no error, this works
    assert true
  end

  test 'should require all except admin' do
    u = User.new
    u.admin = false
    assert(!(u.valid?), 'Should be false')
  end

  test 'should not validate with required values and non-matching passwords' do
    u = User.new
    u.name = 'user'
    u.password = 'password'
    u.password_confirmation = 'confirmation'
    assert(!(u.valid?), 'Should be false')
  end

  test 'check validates with required values and matching passwords' do
    u = User.new
    u.name = 'user'
    u.password = 'password'
    u.password_confirmation = 'password'
    assert(u.valid?, 'Should be true')
  end
end


