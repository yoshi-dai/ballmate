class User < ApplicationRecord
  authenticates_with_sorcery!
  attr_accessor :password, :password_confirmation

  has_many :group_users
  has_many :groups, through: :group_users
  has_many :matchings, through: :groups
  has_many :matching_users, through: :matchings
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

  def self.ransackable_attributes(auth_object = nil)
    %w[]
  end
  
  def self.ransackable_associations(auth_object = nil)
    ['user_profile'] # 検索可能な関連のリストを定義する
  end
end
