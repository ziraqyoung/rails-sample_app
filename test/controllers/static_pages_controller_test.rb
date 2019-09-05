require 'test_helper'
class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @base_title = 'Ruby on Rails Tutorial Sample App'
  end

  test 'Should get home page' do
    get root_url
    assert_response :success
    assert_select 'title', @base_title
  end

  test 'should get help' do
    get help_url
    assert_response :success
    assert_select 'title', "Help | #{@base_title}"
  end

  test 'Should get about' do
    get about_url
    assert_response :success
    assert_select 'title', "About | #{@base_title}"
  end

  test 'should get contact page' do
    get contact_url
    assert_response :success
    assert_select 'title', "Contact | #{@base_title}"
  end
end
