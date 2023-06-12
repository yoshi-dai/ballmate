class ApplicationController < ActionController::Base
  before_action :require_login
  before_action :set_user_id_to_cookie

  def set_user_id_to_cookie
    if current_user
      cookies.signed["user.id"] = current_user.id
    end
  end

  private

  def not_authenticated
    redirect_to login_path, alert: 'ログインしてください。'
  end
end
