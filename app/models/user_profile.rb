class UserProfile < ApplicationRecord
  mount_uploader :image, UserImageUploader

  has_many :profile_soccer_activities, dependent: :destroy
  has_many :favorite_soccer_activities, through: :profile_soccer_activities
  has_many :profile_soccer_equipments, dependent: :destroy
  has_many :soccer_equipments, through: :profile_soccer_equipments
  belongs_to :user

  validates :name, presence: true
  validates :age, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_blank: true
  validates :favorite_player, length: { maximum: 255 }
  validates :position, length: { maximum: 255 }
  validates :role_in_team, length: { maximum: 255 }
  validates :favorite_place, length: { maximum: 255 }
  validates :available_day_of_week, length: { maximum: 255 }
  validates :available_time, length: { maximum: 255 }

  def self.ransackable_attributes(_auth_object = nil)
    ["age", "available_day_of_week", "available_time", "favorite_place", "favorite_player", "name", "position", "role_in_team", "favorite_team"]
  end

  def self.ransackable_associations(_auth_object = nil)
    ["favorite_soccer_activities", "profile_soccer_activities", "profile_soccer_equipments", "soccer_equipments", "user"]
  end
end
