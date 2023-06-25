class User < ApplicationRecord
  authenticates_with_sorcery!
  attr_accessor :password, :password_confirmation

  has_many :group_users, dependent: :destroy
  has_many :groups, through: :group_users
  has_many :matchings, through: :groups
  has_many :matching_users, through: :matchings, source: :users
  has_many :personal_matchings, -> { includes(:users).where.not(users: { id: nil }) }, through: :matching_users, source: :matchings, class_name: 'Matching'
  has_many :chat_requests, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_one :user_profile, dependent: :destroy

  has_many :sent_chat_requests, class_name: 'ChatRequest', foreign_key: 'sender_id'
  has_many :received_chat_requests, class_name: 'ChatRequest', foreign_key: 'receiver_id'

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:password] }

  validates :email, presence: true, uniqueness: true
  validates :password, confirmation: true

  def approved_chat_requests
    sent_chat_requests.where(status: 'approved').or(received_chat_requests.where(status: 'approved'))
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[]
  end

  def self.ransackable_associations(_auth_object = nil)
    ['user_profile'] # 検索可能な関連のリストを定義する
  end

  def name
    self.user_profile.name
  end

  def image
    self.user_profile.image
  end
end
