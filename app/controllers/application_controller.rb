class ApplicationController < ActionController::Base
  include ApplicationHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :update_sanitized_params, if: :devise_controller?
  before_action :load_setting

  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) << :name
  end

  def load_setting
    @setting = Setting.active_setting
  end
end
