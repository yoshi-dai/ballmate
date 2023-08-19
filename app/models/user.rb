class User < ApplicationRecord
  authenticates_with_sorcery!
  attr_accessor :password, :password_confirmation

  has_many :group_users, dependent: :destroy
  has_many :groups, through: :group_users
  has_many :matchings, through: :groups
  has_many :matching_users, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_one :user_profile, dependent: :destroy


  has_many :sent_chat_requests, class_name: 'ChatRequest', foreign_key: 'sender_id', dependent: :destroy
  has_many :received_chat_requests, class_name: 'ChatRequest', foreign_key: 'receiver_id', dependent: :destroy
  has_many :personal_matchings, through: :matching_users, source: :matching, class_name: 'Matching', dependent: :destroy

  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy

  validates :email, presence: true, uniqueness: true, length: { maximum: 255 }
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:password] }, confirmation: true
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:password] }

  delegate :name, to: :user_profile, allow_nil: true
  delegate :image_url, to: :user_profile, allow_nil: true

  enum role: { general: 0, admin: 1 }

  def self.ransackable_attributes(_auth_object = nil)
    %w[]
  end

  def self.ransackable_associations(_auth_object = nil)
    # 検索可能な関連のリストを定義する
    ['user_profile']
  end

  def approved_chat_requests
    sent_chat_requests.where(status: 'approved').or(received_chat_requests.where(status: 'approved'))
  end

  def delete_approved_chat_request_for_user(matching)
    chat_request = ChatRequest.find_by(status: 'approved', sender_id: [matching.users.pluck(:id)[0], matching.users.pluck(:id)[1]], receiver_id: [matching.users.pluck(:id)[0], matching.users.pluck(:id)[1]])
    chat_request.destroy! if chat_request.present?
  end

  def delete_approved_chat_request_for_matching(group)
    chat_request = ChatRequest.find_by(status: 'approved', sender_id: id, matching_id: group.matching.id)
    chat_request.destroy! if chat_request.present?
  end

  def leave_group(group)
    group_user = group_users.find_by(group_id: group.id)
    group_user.destroy!
  end

  def create_notification_chat_request!(current_user, chat_request)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ?", current_user.id, chat_request.receiver_id, 'follow'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end
 
end
