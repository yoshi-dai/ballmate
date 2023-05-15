class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: 'success'
    else
      flash.now[:danger] = t('.fail')
      render :new
    end
  end
  
  def index
    @users = User.includes(:user_profile).where.not(id: current_user.id).where.not(user_profiles: { name: nil })
    @chat_request = ChatRequest.new
  end


  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end

