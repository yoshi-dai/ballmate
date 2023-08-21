class Matching < ApplicationRecord
  belongs_to :group

  has_many :matching_users, dependent: :destroy
  has_many :users, through: :matching_users
  has_many :chat_requests, dependent: :destroy
  # has_many :requested_users, through: :chat_requests, source: :user
  has_many :received_chat_requests, class_name: 'ChatRequest', dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_one :matching_profile, dependent: :destroy

  validates :name, length: { maximum: 255 }
  validates :place, length: { maximum: 255 }
  validates :public_flag, inclusion: { in: [true, false] }
  validate :date_cannot_be_in_the_past

  def date_cannot_be_in_the_past
    errors.add(:date, "は今日以降の日付を選択してください") if date.present? && date < Date.today
  end

  def self.ransackable_attributes(_auth_object = nil)
    ['date', 'name', 'place', 'temperature', 'time_zone']
  end

  def self.ransackable_associations(_auth_object = nil)
    ['matching_profile'] # 検索可能な関連のリストを定義する
  end

  def create_notification_matching!(current_user, matching)
    temp_ids = matching.group.users.select(:id).where.not(id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_matching!(current_user, matching, temp_id['id'])
    end
  end

  def save_notification_matching!(current_user, matching, visited_id)
    notification = current_user.active_notifications.new(
      matching_id: matching.id,
      visited_id: visited_id,
      action: 'matching_follow'
    )
    notification.save if notification.valid?
  end

  def destroy_notifications_matching!(current_user, matching)
    temp_ids = matching.group.users.select(:id).where.not(id: current_user.id).distinct
    temp_ids.each do |temp_id|
      destroy_notification_matching!(current_user, matching, temp_id['id'])
    end
  end

  def destroy_notification_matching!(current_user, matching, visited_id)
    notification = current_user.active_notifications.find_by(
      matching_id: matching.id,
      visited_id: visited_id,
      action: 'matching_follow'
    )
    notification.destroy! if notification.present?
  end

  def create_notification_approve_matching!(current_user, matching)
    temp_ids = matching.group.users.select(:id).where.not(id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_approve_matching!(current_user, matching, temp_id['id'])
    end
  end

  def save_notification_approve_matching!(current_user, matching, visited_id)
    notification = current_user.active_notifications.new(
      matching_id: matching.id,
      visited_id: visited_id,
      action: 'matching_approve'
    )
    notification.save if notification.valid?
  end
end
