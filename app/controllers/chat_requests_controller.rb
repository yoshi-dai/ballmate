class ChatRequestsController < ApplicationController
  include ChatRequestsHelper
  
  def create
    if params[:chat_request] && params[:chat_request][:receiver_id].present? # ユーザーへのチャットリクエストの場合
      handle_create_user_chat_request
    elsif params[:matching_id].present? # マッチングへのチャットリクエストの場合
      handle_create_matching_chat_request
    end
  end

  def approve
    if params[:user_id].present? && params[:matching_id].blank? # ユーザーへのチャットリクエストの場合
      handle_user_approval(params[:user_id])
    elsif params[:matching_id].present? # マッチングへのチャットリクエストの場合
      handle_matching_approval(params[:user_id], params[:matching_id])
    end
  end

  def cancel # チャットリクエストの送信者が削除する場合
    if params[:user_id].present? # ユーザーへのチャットリクエストの場合
      handle_cancel_user_chat_request(params[:user_id])
    elsif params[:matching_id].present? # マッチングへのチャットリクエストの場合
      handle_cancel_matching_chat_request(params[:matching_id])
    end
  end

  def reject # チャットリクエストの受信者が削除する場合
    if params[:user_id].present? && params[:matching_id].blank? # ユーザーへのチャットリクエストの場合
      handle_reject_user_chat_request(params[:user_id])
    elsif params[:matching_id].present? # マッチングへのチャットリクエストの場合
      handle_reject_matching_chat_request(params[:user_id], params[:matching_id])
    end
  end

  private

  def chat_request_params
    params.require(:chat_request).permit(:receiver_id, :matching_id)
  end

  def handle_create_user_chat_request
    if create_user_chat_request
      redirect_to users_path, success: t('.success')
    else
      @users = User.where.not(id: User.matched(current_user).pluck(:id)).includes(:user_profile)
      flash.now[:warning] = t('.failure')
      render 'users/index'
    end
  end

  def handle_create_matching_chat_request
    if create_matching_chat_request
      redirect_to matchings_path, success: t('.success')
    else
      redirect_to matchings_path, warning: t('.failure')
    end
  end

  def handle_user_approval(sender_id)
    chat_request = current_user.received_chat_requests.find_by(sender_id: sender_id, status: 'pending')
    @matching = create_personal_matching(chat_request)

    if @matching.present?
      redirect_to matching_path(@matching), success: t('.success')
    else
      redirect_to approval_pending_users_path, warning: t('.failure')
    end
  end

  def handle_matching_approval(sender_id, matching_id)
    matching = Matching.find(matching_id)
    chat_request = current_user.matchings.find(matching_id).received_chat_requests.find_by(matching_id: matching_id, sender_id: sender_id, status: 'pending')
  
    if add_sender_to_group_matching(chat_request, matching)
      redirect_to matching_profile_path(matching.matching_profile), success: t('.success')
    else
      redirect_to matching_profile_path(matching.matching_profile), warning: t('.failure')
    end
  end

  def handle_cancel_user_chat_request(receiver_id)
    chat_request = current_user.sent_chat_requests.find_by(receiver_id: receiver_id, status: 'pending')
    if cancel_user_chat_request(chat_request)
      redirect_to requested_users_path, success: t('.success')
    else
      redirect_to requested_users_path, warning: t('.failure')
    end
  end

  def handle_cancel_matching_chat_request(matching_id)
    matching = Matching.find(matching_id)
    chat_request = current_user.sent_chat_requests.find_by(matching_id: matching_id, status: 'pending')
    if cancel_matching_chat_request(chat_request, matching)
      redirect_to requested_matchings_path, success: t('.success')
    else
      redirect_to requested_matchings_path, warning: t('.failure')
    end
  end

  def handle_reject_user_chat_request(sender_id)
    chat_request = current_user.received_chat_requests.find_by(sender_id: sender_id, status: 'pending')
    if reject_user_chat_request(chat_request)
      redirect_to approval_pending_users_path, success: t('.success')
    else
      redirect_to approval_pending_users_path, warning: t('.failure')
    end
  end

  def handle_reject_matching_chat_request(sender_id, matching_id)
    chat_request = current_user.matchings.find(matching_id).received_chat_requests.find_by(matching_id: matching_id, sender_id: sender_id, status: 'pending')
    if reject_matching_chat_request(chat_request)
      redirect_to approval_pending_matchings_path, success: t('.success')
    else
      redirect_to approval_pending_matchings_path, error: t('.failure')
    end
  end
end
