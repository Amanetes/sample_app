# frozen_string_literal: true

require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test 'unsuccessful edit' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: '',
                                              email: 'foo@invalid',
                                              password: 'foo',
                                              password_confirmation: 'bar' } }
    assert_template 'users/edit'
    assert_select 'div#error_explanation'
    assert_select 'div.alert.alert-danger', 'The form contains 4 errors.'
  end

  test 'successful edit with friendly forwarding' do
    get edit_user_path(@user) # Перейти на страницу редактирования конкретного пользователя без логина
    log_in_as(@user) # Залогиниться
    assert_redirected_to edit_user_url(@user) # Убедиться, что попали на страницу редактирования
    # Убедиться, что из сессии исчез URL и следующий редирект будет уже на страницу пользователя
    # Чтобы последующие входы не редиректили на страницу редактирования
    assert_nil session[:forwarding_url]
    name = 'Foo Bar'
    email = 'foo@bar.com'
    patch user_path(@user), params: { user: { name:,
                                              email:,
                                              password: '',
                                              password_confirmation: '' } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
