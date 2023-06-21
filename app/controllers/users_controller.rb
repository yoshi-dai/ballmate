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
    excluded_user_ids = [
      current_user.id, # 現在のユーザー自身
      current_user.sent_chat_requests.where(status: 'pending').pluck(:receiver_id), # 申請済みのユーザー
      current_user.received_chat_requests.where(status: 'pending').pluck(:sender_id), # 承認待ちのユーザー
      current_user.matchings.flat_map(&:user_ids) # マッチング済みのユーザー
    ].flatten.uniq
    @q = User.includes(:user_profile).ransack(params[:q])
    @users = @q.result(distinct: true).where.not(id: excluded_user_ids).where.not(user_profiles: { name: nil }).page(params[:page])
    @chat_request = ChatRequest.new
  end

  def show
    @user = User.find(params[:id])
    @user_profile = @user.user_profile
  end
  
  def matched_users
    @q = User.includes(:user_profile).ransack(params[:q])
    @users = @q.result(distinct: true).where(id: current_user.matchings.flat_map(&:user_ids)).where.not(id: current_user.id).page(params[:page])
    render 'users/index'
  end
  
  def requested_users
    @q = User.includes(:user_profile).ransack(params[:q], search_key: "#{action_name}_users")
    @chat_requests = current_user.sent_chat_requests.includes(receiver: :user_profile).where(status: 'pending').where.not(receiver: nil)
    @users = @q.result(distinct: true).where(id: @chat_requests.map(&:receiver_id)).where.not(id: current_user.id).page(params[:page])
    render 'users/index'
  end

  def approval_pending_users
    @q = User.includes(:user_profile).ransack(params[:q])
    @chat_requests = current_user.received_chat_requests.includes(sender: :user_profile).where(status: 'pending')
    @users = @q.result(distinct: true).where(id: @chat_requests.map(&:sender_id)).where.not(id: current_user.id).page(params[:page])
    render 'users/index'
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end