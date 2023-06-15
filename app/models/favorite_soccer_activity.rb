class FavoriteSoccerActivity < ApplicationRecord
  has_many :profile_soccer_activities, dependent: :destroy
  has_many :user_profiles, through: :profile_soccer_activities
end
