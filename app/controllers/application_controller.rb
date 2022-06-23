# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Методы заинклюженные из SessionsHelper доступны в контроллерах
  include SessionsHelper
end
