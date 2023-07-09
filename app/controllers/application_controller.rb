class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :error
  before_action :require_login
  before_action :set_user_id_to_cookie

  def set_user_id_to_cookie
    cookies.signed["user.id"] = current_user.id if current_user
  end

  private

  def not_authenticated
    redirect_to main_app.login_path, error: t('user_sessions.not_authenticated')
  end
end
