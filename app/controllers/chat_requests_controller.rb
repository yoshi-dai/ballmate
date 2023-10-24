class ChatRequestsController < ApplicationController
  include ChatRequestsHelper
  
  def create
    begin
      if params[:chat_request].present? && params[:chat_request][:receiver_id].present?
        create_user_chat_request
        redirect_to users_path, success: t('.success')
      elsif params[:matching_id].present?
        create_matching_chat_request
        redirect_to matchings_path, success: t('.success')
      end
    rescue CustomError => e
      handle_error(e)
    rescue StandardError => e
      handle_error(e)
    end
  end

  def approve
    if params[:user_id].present? && params[:matching_id].blank? # ユーザーへのチャットリクエストの場合
      chat_request = current_user.received_chat_requests.find_by(sender_id: params[:user_id], status: 'pending')
      
      if chat_request
        matching = nil

        ActiveRecord::Base.transaction do
          chat_request.update(status: 'approved')

          group = Group.create(name: "Group-#{SecureRandom.hex(4)}")

          group.users << current_user
          group.users << chat_request.sender

          matching = Matching.create(name: group.name, group_id: group.id, public_flag: false)
          matching.users << current_user
          matching.users << chat_request.sender

          current_user.create_notification_approve_chat_request!(current_user, chat_request)
        end
        redirect_to matching_path(matching), success: t('.success')
      else
        redirect_to users_path, worning: t('.failure')
      end
    elsif params[:matching_id].present? # マッチングへのチャットリクエストの場合
      matching = Matching.find(params[:matching_id])
      chat_request = current_user.matchings.find(params[:matching_id]).received_chat_requests.find_by(matching_id: params[:matching_id], sender_id: params[:user_id], status: 'pending')
      if chat_request
        group = Group.find(matching.group_id)
        ActiveRecord::Base.transaction do
          chat_request.update(status: 'approved')

          group = Group.find(chat_request.matching.group_id)
          group.users << chat_request.sender

          chat_request.destroy!

          matching.create_notification_approve_matching!(current_user, matching)
        end
        redirect_to matching_profile_path(group.matching.matching_profile), success: t('.success')
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
