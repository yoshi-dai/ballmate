class UserProfile < ApplicationRecord
  mount_uploader :image, UserImageUploader

  has_many :profile_soccer_activities, dependent: :destroy
  has_many :favorite_soccer_activities, through: :profile_soccer_activities
  has_many :profile_soccer_equipments, dependent: :destroy
  has_many :soccer_equipments, through: :profile_soccer_equipments
  belongs_to :user

  enum available_time: { morning: 0, midday: 1, afternoon: 2, night: 3, anytime: 4 }
  DAYS_OF_WEEK = ['日', '月', '火', '水', '木', '金', '土']

  def self.ransackable_attributes(auth_object = nil)
    ["active_area", "age", "available_day_of_week", "available_time", "created_at", "favorite_place", "favorite_player", "id", "image", "image_cache", "name", "position", "role_in_team", "favorite_team"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["favorite_soccer_activities", "profile_soccer_activities", "profile_soccer_equipments", "soccer_equipments", "user"]
  end
end
