# frozen_string_literal: true

require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test 'layout links' do
    get root_path
    assert_template 'static_pages/home'
    assert_select 'a[href=?]', root_path, count: 2
    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', contact_path
    assert_select 'a[href=?]', 'https://news.railstutorial.org/'
    assert_select 'a[href=?]', login_path
  end

  test 'layout links when logged_in' do
    log_in_as(@user)
    get root_path
    assert_select 'a[href=?]', users_path
    get users_path
    assert_template 'users/index'
    assert_select 'title', full_title('All users')
  end

  test 'log in layout' do
    get login_path
    assert_select 'title', full_title('Log in')
  end

  test 'sign up layout' do
    get signup_path
    assert_select 'title', full_title('Sign up')
  end
end
