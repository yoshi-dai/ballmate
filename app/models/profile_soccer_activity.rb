class ProfileSoccerActivity < ApplicationRecord
  belongs_to :user_profile
  belongs_to :favorite_soccer_activity

  validates :user_profile_id, uniqueness: { scope: :favorite_soccer_activity_id }
end
