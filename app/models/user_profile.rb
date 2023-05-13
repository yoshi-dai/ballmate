class UserProfile < ApplicationRecord
  mount_uploader :image, UserImageUploader

  has_many :profile_soccer_activities, dependent: :destroy
  has_many :favorite_soccer_activities, through: :profile_soccer_activities
  belongs_to :user

  EQUIPMENT_CHOICES = ['スパイク', 'マーカー', 'レガース', 'ボール', 'ビブス']
  DAYS_OF_WEEK = ['日', '月', '火', '水', '木', '金', '土']
end
