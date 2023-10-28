class MatchingsController < ApplicationController
  include MatchingsHelper
  include GeocodingHelper
  require 'date'
  require_relative '../services/weather_service'

  before_action :set_matching, only: %i[show edit update destroy]
  before_action :set_q, only: %i[index matched_matchings requested_matchings approval_pending_matchings]
  before_action :set_other_user, only: %i[show edit]

  def index
    @matchings = filtered_matchings.page(params[:page])
  end

  def show
    @messages = @matching.messages.includes(:user).order(created_at: :asc)
  end

  def edit; end

  def update
    if @matching.update(matching_params)
      redirect_to @matching, success: t('.success')
    else
      flash.now[:warning] = t('.failure')
      render 'show'
    end
  end

  def destroy
    delete_matching!(@matching)
    redirect_to matchings_path, success: t('.success')
  end

  def matched_matchings
    @matchings = filtered_matched_matchings.page(params[:page])
  end

  def requested_matchings
    @matchings = filtered_requested_matchings.page(params[:page])
  end

  def approval_pending_matchings
    @matchings = filterd_approval_pending_matchings.page(params[:page])
  end

  private

  def matching_params
    params.require(:matching).permit(:name, :date, :scheduled_time, :place, :public_flag)
  end
  
  def set_q
    @q = Matching.includes(:matching_profile, :group).ransack(params[:q])
  end

  def set_matching
    @matching = Matching.find(params[:id])
  end

  def set_other_user
    @user = other_user
  end

  def other_user
    @matching.users.where.not(id: current_user.id).first
  end
  
  def filtered_matchings
    @q.result(distinct: true)
    .where(public_flag: 1) # 公開中のマッチング
    .where.not(id: excluded_matchings_ids) # 申請済みのマッチングと承認済みのマッチングを除外
    .includes(:matching_profile, :group)
  end

  def excluded_matchings_ids
    [
      current_user.matchings.pluck(:id), # 承認済みのマッチング
      current_user.sent_chat_requests.where(status: 'pending').pluck(:matching_id) # 申請済みのマッチング
    ].flatten.uniq
  end

  def filtered_matched_matchings
    @q.result(distinct: true)
    .where(id: current_user.matchings.pluck(:id)) # 承認済みのマッチング
    .where.not(id: current_user.personal_matchings.pluck(:id).uniq) # ユーザー間での個別マッチングを除外
    .includes(:matching_profile, :group)
  end

  def filtered_requested_matchings
    @chat_requests = current_user.sent_chat_requests.where(status: 'pending')
    @q.result(distinct: true)
    .where(public_flag: 1) # 公開中のマッチング
    .where(id: @chat_requests.map(&:matching_id)) # 申請済みのマッチング
    .includes(:matching_profile, :group)
  end

  def filterd_approval_pending_matchings
    @chat_requests = ChatRequest.includes(:sender).where(matching: current_user.matchings, status: 'pending')
    @q.result(distinct: true)
    .where(public_flag: 1) # 公開中のマッチング
    .where(id: @chat_requests.map(&:matching_id)) # 承認待ちのマッチング
    .includes(:matching_profile, :group)
  end
end
