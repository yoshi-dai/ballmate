class ChatRequestsController < ApplicationController
  def create
    receiver_id = params[:chat_request][:receiver_id] # 受信者のユーザーID（フォームデータから取得）

    @chat_request = ChatRequest.new(sender_id: current_user.id, receiver_id: receiver_id, status: :pending)
    if @chat_request.save
      redirect_to users_path, notice: 'チャットリクエストを送信しました。'
    else
      @users = User.where.not(id: current_user.id).includes(:user_profile)
      @chat_request = ChatRequest.new
      render 'users/index'
    end
  end

  def approve
    @chat_request = current_user.received_chat_requests.find_by(sender_id: params[:user_id], status: 'pending')
    if @chat_request
      @chat_request.update(status: 'approved')
      group = Group.create
    
      # ユーザーをグループに追加
      group.users << current_user
      group.users << @chat_request.sender
    
      # マッチングの作成
      matching = Matching.create(name: group.name)
      matching.users << current_user
      matching.users << @chat_request.sender
    
      # 承認後の処理(一時的)
      redirect_to users_path, notice: 'チャットリクエストを承認しました。'
    else
      # 承認できなかった場合の処理
      redirect_to users_path, alert: 'チャットリクエストの承認に失敗しました。'
    end
  end

  def cancel
    @chat_request = current_user.sent_chat_requests.find_by(receiver_id: params[:user_id], status: 'pending')
    if @chat_request
      @chat_request.destroy!
      redirect_to users_path, notice: 'チャットリクエストをキャンセルしました。'
    else
      redirect_to users_path, alert: 'チャットリクエストのキャンセルに失敗しました。'
    end
  end

  def reject
    @chat_request = current_user.received_chat_requests.find_by(sender_id: params[:user_id], status: 'pending')
    if @chat_request
      @chat_request.update(status: 'rejected')
      @chat_request.destroy!
      redirect_to users_path, notice: 'チャットリクエストを拒否しました。'
    else
      redirect_to users_path, alert: 'チャットリクエストの拒否に失敗しました。'
    end
  end

  private

  def chat_request_params
    params.require(:chat_request).permit(:receiver_id, :matching_id)
  end
end
