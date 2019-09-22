require 'test_helper'

class UsersListTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test 'list users reirect when not logged in' do
    get users_path
    assert_redirected_to login_path
    assert_not flash.empty?
  end

  test 'list users when logged in' do
    log_in_as @user
    get users_path
    assert_template 'users/index'
  end
end
