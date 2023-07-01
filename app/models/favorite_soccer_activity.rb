class FavoriteSoccerActivity < ApplicationRecord
  has_many :profile_soccer_activities, dependent: :destroy
  has_many :user_profiles, through: :profile_soccer_activities

  validates :soccer_type, presence: true, length: { maximum: 255 }

  def self.ransackable_attributes(_auth_object = nil)
    ["soccer_type"]
  end
end
