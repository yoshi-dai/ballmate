class FavoriteSoccerActivity < ApplicationRecord
  has_many :profile_soccer_activities, dependent: :destroy
  has_many :user_profiles, through: :profile_soccer_activities

  def self.ransackable_attributes(auth_object = nil)
    ["soccer_type"]
  end
end
