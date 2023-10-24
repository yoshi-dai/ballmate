class ChatRequestsController < ApplicationController
  include ChatRequestsHelper
  
  def create
    if params[:chat_request] && params[:chat_request][:receiver_id].present? # ユーザーへのチャットリクエストの場合
      create_user_chat_request
    elsif params[:matching_id].present? # マッチングへのチャットリクエストの場合
      create_matching_chat_request
    end
  end

  def approve
    if params[:user_id].present? && params[:matching_id].blank? # ユーザーへのチャットリクエストの場合
      handle_user_approval(params[:user_id])
    elsif params[:matching_id].present?
      handle_matching_approval(params[:user_id], params[:matching_id]) # マッチングへのチャットリクエストの場合
    end
  end

  def cancel
    if params[:user_id].present? # ユーザーへのチャットリクエストの場合
      @chat_request = current_user.sent_chat_requests.find_by(receiver_id: params[:user_id], status: 'pending')
      if @chat_request
        @chat_request.destroy!
        current_user.destroy_notification_chat_request!(current_user, @chat_request)
        redirect_to users_path, success: t('.success')
      else
        redirect_to users_path, warning: t('.failure')
      end
    elsif params[:matching_id].present? # マッチングへのチャットリクエストの場合
      matching = Matching.find(params[:matching_id])
      @chat_request = current_user.sent_chat_requests.find_by(matching_id: params[:matching_id], status: 'pending')
      if @chat_request
        @chat_request.destroy!
        matching.destroy_notifications_matching!(current_user, matching)
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
        @chat_request.destroy!
        redirect_to users_path, success: t('.success')
      else
        redirect_to users_path, error: t('.failure')
      end
    elsif params[:matching_id].present? # マッチングへのチャットリクエストの場合
      @chat_request = current_user.matchings.find(params[:matching_id]).received_chat_requests.find_by(matching_id: params[:matching_id], sender_id: params[:user_id], status: 'pending')
      if @chat_request
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

  def handle_error(error)
    Rails.logger.error("Error: #{error.message}")
    flash[:error] = 'An unexpected error occurred.'
    redirect_to root_path
  end
end
