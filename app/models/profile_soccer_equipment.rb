class ProfileSoccerEquipment < ApplicationRecord
  belongs_to :user_profile
  belongs_to :soccer_equipment
end
