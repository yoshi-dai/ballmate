class Matching < ApplicationRecord
  belongs_to :group

  has_many :matching_users, dependent: :destroy
  has_many :users, through: :matching_users

  has_many :chat_requests, dependent: :destroy
  has_many :requested_users, through: :chat_requests, source: :user
  has_many :received_chat_requests, class_name: 'ChatRequest', foreign_key: 'matching_id', dependent: :destroy
  has_many :messages, dependent: :destroy
  has_one :matching_profile, dependent: :destroy

  validates :name, presence: true, length: { maximum: 255 }

  def self.ransackable_attributes(_auth_object = nil)
    ['date', 'name', 'place', 'temperature', 'time_zone']
  end

  def self.ransackable_associations(_auth_object = nil)
    ['matching_profile'] # 検索可能な関連のリストを定義する
  end
end
