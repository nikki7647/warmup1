require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
  end

  test "successful add should return 1" do
	User.delete_all
    post :add, {:user => '1', :password => 'asdf'}
    resp = JSON.parse(@response.body)
	assert_equal 1, resp['errCode']
    User.delete_all
  end
  
  test "duplicate add should return -2" do
	User.delete_all
    post :add, {:user => '1', :password => 'asdf'}
	post :add, {:user => '1', :password => 'asdf'}
    resp = JSON.parse(@response.body)
	assert_equal -2, resp['errCode']
    User.delete_all
  end
  
  test "empty password add should return 1" do
	User.delete_all
    post :add, {:user => '1', :password => ''}
    resp = JSON.parse(@response.body)
	assert_equal 1, resp['errCode']
    User.delete_all
  end
  
  test "empty user add should return -3" do
	User.delete_all
    post :add, {:user => '', :password => 'asdf'}
    resp = JSON.parse(@response.body)
	assert_equal -3, resp['errCode']
    User.delete_all
  end
  
  test "long password add should return -4" do
	User.delete_all
    post :add, {:user => '1', :password => 'asdfaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'}
    resp = JSON.parse(@response.body)
	assert_equal -4, resp['errCode']
    User.delete_all
  end
  
  test "long user add should return -3" do
	User.delete_all
    post :add, {:user => 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', :password => 'asdf'}
    resp = JSON.parse(@response.body)
	assert_equal -3, resp['errCode']
    User.delete_all
  end
  
  test "successful login should return count = 2" do
	User.delete_all
    post :add, {:user => '1', :password => 'asdf'}
	post :login, {:user => '1', :password => 'asdf'}
    resp = JSON.parse(@response.body)
	assert_equal 1, resp['errCode']
	assert_equal 2, resp['count']
    User.delete_all
  end
  
  test "unfound user login should return -1" do
	User.delete_all
    post :add, {:user => '1', :password => 'asdf'}
	post :login, {:user => '2', :password => 'asdf'}
    resp = JSON.parse(@response.body)
	assert_equal -1, resp['errCode']

    User.delete_all
  end
  
  test "wrong password login should return -1" do
	User.delete_all
    post :add, {:user => '1', :password => 'asdf'}
	post :login, {:user => '2', :password => 'ghjk'}
    resp = JSON.parse(@response.body)
	assert_equal -1, resp['errCode']

    User.delete_all
  end
  
  test "reset fixture should return 1" do
	User.delete_all
    post :resetFixture
	
    resp = JSON.parse(@response.body)
	assert_equal 1, resp['errCode']

    User.delete_all
  end
  
  
end
