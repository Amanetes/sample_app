# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Методы заинклюженные из SessionsHelper доступны в контроллерах
  include SessionsHelper

  private

  # Confirms logged-in user
  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = 'Please log in.'
    redirect_to login_url, status: :see_other
  end
end
