class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  before_action :set_q, only: %i[index matched_users requested_users approval_pending_users matching_having_users]

  def index
    excluded_user_ids = [
      current_user.id,
      current_user.sent_chat_requests.where(status: 'pending').pluck(:receiver_id), # 申請済みのユーザー
      current_user.received_chat_requests.where(status: 'pending').pluck(:sender_id), # 承認待ちのユーザー
      current_user.approved_chat_requests.flat_map { |cr| [cr.sender_id, cr.receiver_id] }.uniq # 個別でマッチングしているユーザー
    ].flatten.uniq

    @users = @q.result(distinct: true).where.not(id: excluded_user_ids).where.not(user_profiles: { name: nil }).page(params[:page])
    @chat_request = ChatRequest.new
  end

  def show
    @user = User.find(params[:id])
    @user_profile = @user.user_profile
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id # ログイン状態にする
      redirect_to new_user_profile_path, success: t('.success')
    else
      flash.now[:warning] = t('.failure')
      render :new
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy!
    redirect_to :root, success: t('.success')
  end

  def matched_users
    @users = @q.result(distinct: true).where(id: current_user.approved_chat_requests.flat_map { |cr| [cr.sender_id, cr.receiver_id] }.uniq).where.not(id: current_user.id).page(params[:page])
  end

  def requested_users
    @chat_requests = current_user.sent_chat_requests.includes(receiver: :user_profile).where(status: 'pending').where.not(receiver: nil)
    @users = @q.result(distinct: true).where(id: @chat_requests.map(&:receiver_id)).where.not(id: current_user.id).page(params[:page])
  end

  def approval_pending_users
    @chat_requests = current_user.received_chat_requests.includes(sender: :user_profile).where(status: 'pending')
    @users = @q.result(distinct: true).where(id: @chat_requests.map(&:sender_id)).where.not(id: current_user.id).page(params[:page])
  end

  def matching_having_users
    @matching = Matching.find(params[:matching_id])
    @users = @q.result(distinct: true).where(id: @matching.group.users.map(&:id)).where.not(id: current_user.id).page(params[:page])
    @chat_request = ChatRequest.new # rendersした先でチャットリクエストを送るために@chat_requestを定義している
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def set_user
    @user = User.includes(:user_profile).find(params[:id])
  end

  def set_q
    @q = User.includes(:user_profile).ransack(params[:q])
  end
end
