class User < ApplicationRecord
  authenticates_with_sorcery!
  attr_accessor :password, :password_confirmation

  has_many :group_users
  has_many :groups, through: :group_users
  has_many :matchings, through: :groups
  has_many :chat_requests, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_one :user_profile, dependent: :destroy

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:password] }

  validates :email, presence: true, uniqueness: true
  validates :password, confirmation: true
end
