class Matching < ApplicationRecord
  belongs_to :group

  has_many :matching_users, dependent: :destroy
  has_many :users, through: :matching_users

  has_many :chat_requests, dependent: :destroy
  has_many :requested_users, through: :chat_requests, source: :user
  has_many :received_chat_requests, class_name: 'ChatRequest'
  has_many :messages, dependent: :destroy
  has_one :matching_profile, dependent: :destroy

  def create_matching_profile
    # 既に関連付けられたマッチングプロフィールがある場合は何もしない
    return matching_profile if matching_profile

    # 関連付けられたマッチングプロフィールがない場合は新規作成
    MatchingProfile.create(matching_id: id)

    # 作成されたマッチングプロフィールを返す
  end

  def self.ransackable_attributes(_auth_object = nil)
    ['date', 'name', 'place', 'temperature', 'time_zone']
  end

  def self.ransackable_associations(_auth_object = nil)
    ['matching_profile'] # 検索可能な関連のリストを定義する
  end
end
