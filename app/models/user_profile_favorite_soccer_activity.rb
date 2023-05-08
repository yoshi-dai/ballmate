class UserProfileFavoriteSoccerActivity < ApplicationRecord
  belongs_to :user_profile
  belongs_to :favorite_soccer_activity
end
