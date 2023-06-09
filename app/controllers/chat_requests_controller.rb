class ChatRequestsController < ApplicationController
  def create
    if params[:chat_request] && params[:chat_request][:receiver_id].present? # ユーザーへのチャットリクエストの場合
      receiver_id = params[:chat_request][:receiver_id] # 受信者のユーザーID（フォームデータから取得）

      @chat_request = ChatRequest.new(sender_id: current_user.id, receiver_id:, status: :pending)
      if @chat_request.save
        redirect_to users_path, success: t('.success')
      else
        @users = User.where.not(id: current_user.id).includes(:user_profile)
        flash.now[:warning] = t('.failure')
        render 'users/index'
      end
    elsif params[:matching_id].present? # マッチングへのチャットリクエストの場合
      matching_id = params[:matching_id] # マッチングID（フォームデータから取得）
      @chat_request = ChatRequest.new(sender_id: current_user.id, matching_id:, status: :pending)
      if @chat_request.save
        redirect_to matchings_path, success: t('.success')
      else
        @matchings = Matching.where.not(user_id: current_user.id).includes(:matching_profile)
        flash.now[:warning] = t('.failure')
        render 'matchings/index'
      end
    end
  end

  def approve
    if params[:user_id].present? && params[:matching_id].blank? # ユーザーへのチャットリクエストの場合
      chat_request = current_user.received_chat_requests.find_by(sender_id: params[:user_id], status: 'pending')

      if chat_request
        chat_request.update(status: 'approved')

        group = Group.create(name: "Group-#{SecureRandom.hex(4)}")

        group.users << current_user
        group.users << chat_request.sender

        matching = Matching.create(name: group.name, group_id: group.id, public_flag: false)
        matching.users << current_user
        matching.users << chat_request.sender

        redirect_to matching_path(matching.id), success: t('.success')
      else
        redirect_to users_path, worning: t('.failure')
      end
    elsif params[:matching_id].present? # マッチングへのチャットリクエストの場合
      chat_request = current_user.matchings.find(params[:matching_id]).received_chat_requests.find_by(matching_id: params[:matching_id], sender_id: params[:user_id], status: 'pending')
      if chat_request
        chat_request.update(status: 'approved')

        group = Group.find(chat_request.matching.group_id)
        group.users << chat_request.sender

        chat_request.destroy!

        redirect_to matching_profile_path(group.matching.matching_profile.id), success: t('.success')
      else
        redirect_to matchings_path, warning: t('.failure')
      end
    end
  end

  def cancel
    if params[:user_id].present? # ユーザーへのチャットリクエストの場合
      @chat_request = current_user.sent_chat_requests.find_by(receiver_id: params[:user_id], status: 'pending')
      if @chat_request
        @chat_request.destroy!
        redirect_to users_path, success: t('.success')
      else
        redirect_to users_path, warning: t('.failure')
      end
    elsif params[:matching_id].present? # マッチングへのチャットリクエストの場合
      @chat_request = current_user.sent_chat_requests.find_by(matching_id: params[:matching_id], status: 'pending')
      if @chat_request
        @chat_request.destroy!
        redirect_to matchings_path, success: t('.success')
      else
        redirect_to matchings_path, warning: t('.failure')
      end
    end
  end

  def reject
    if params[:user_id].present? && params[:matching_id].blank? # ユーザーへのチャットリクエストの場合
      @chat_request = current_user.received_chat_requests.find_by(sender_id: params[:user_id], status: 'pending')
      if @chat_request
        @chat_request.update(status: 'rejected')
        @chat_request.destroy!
        redirect_to users_path, success: t('.success')
      else
        redirect_to users_path, error: t('.failure')
      end
    elsif params[:matching_id].present? # マッチングへのチャットリクエストの場合
      @chat_request = current_user.matchings.find(params[:matching_id]).received_chat_requests.find_by(matching_id: params[:matching_id], sender_id: params[:user_id], status: 'pending')
      if @chat_request
        @chat_request.update(status: 'rejected')
        @chat_request.destroy!
        redirect_to matchings_path, success: t('.success')
      else
        redirect_to matchings_path, error: t('.failure')
      end
    end
  end

  private

  def chat_request_params
    params.require(:chat_request).permit(:receiver_id, :matching_id)
  end
end
