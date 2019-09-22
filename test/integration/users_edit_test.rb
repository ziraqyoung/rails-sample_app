require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test 'unsuccessfull edits' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user),
          params: {
            user: {
              name: '',
              email: 'foo@invalid',
              password: 'foo',
              password_confirmation: ''
            }
          }
    assert_template 'users/edit'
    assert_select 'div.alert', 'This form contains 4 errors'
  end

  test 'successfull edits with friendly forwading' do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name = 'Foo Bar'
    email = 'foobar@example.org'
    patch user_path(@user),
          params: {
            user: {
              name: name, email: email, password: '', password_confirmation: ''
            }
          }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
