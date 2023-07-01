class User < ApplicationRecord
  authenticates_with_sorcery!
  attr_accessor :password, :password_confirmation

  has_many :group_users, dependent: :destroy
  has_many :groups, through: :group_users
  has_many :matchings, through: :groups
  has_many :matching_users, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_one :user_profile, dependent: :destroy

  has_many :sent_chat_requests, class_name: 'ChatRequest', foreign_key: 'sender_id', dependent: :destroy
  has_many :received_chat_requests, class_name: 'ChatRequest', foreign_key: 'receiver_id', dependent: :destroy
  has_many :personal_matchings, through: :matching_users, source: :matching, class_name: 'Matching', dependent: :destroy

  validates :email, presence: true, uniqueness: true, length: { maximum: 255 }
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:password] }, confirmation: true
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:password] }

  delegate :name, to: :user_profile, allow_nil: true
  delegate :image_url, to: :user_profile, allow_nil: true

  def approved_chat_requests
    sent_chat_requests.where(status: 'approved').or(received_chat_requests.where(status: 'approved'))
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[]
  end

  def self.ransackable_associations(_auth_object = nil)
    # 検索可能な関連のリストを定義する
    ['user_profile'] 
  end
end
