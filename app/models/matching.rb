class Matching < ApplicationRecord
  belongs_to :group

  has_many :matching_users, dependent: :destroy
  has_many :users, through: :matching_users
  has_many :chat_requests, dependent: :destroy
  has_many :requested_users, through: :chat_requests, source: :user
  has_many :received_chat_requests, class_name: 'ChatRequest', foreign_key: 'matching_id', dependent: :destroy
  has_many :messages, dependent: :destroy
  has_one :matching_profile, dependent: :destroy

  validates :name, length: { maximum: 255 }
  validates :place, length: { maximum: 255 }
  validates :public_flag, inclusion: { in: [true, false] }
  validate :date_cannot_be_in_the_past


  def date_cannot_be_in_the_past
    if date.present? && date < Date.today
      errors.add(:date, "は今日以降の日付を選択してください")
    end
  end

  def self.ransackable_attributes(_auth_object = nil)
    ['date', 'name', 'place', 'temperature', 'time_zone']
  end

  def self.ransackable_associations(_auth_object = nil)
    ['matching_profile'] # 検索可能な関連のリストを定義する
  end
end
