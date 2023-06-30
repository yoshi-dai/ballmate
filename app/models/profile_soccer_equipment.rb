class ProfileSoccerEquipment < ApplicationRecord
  belongs_to :user_profile
  belongs_to :soccer_equipment

  validates :user_profile_id, uniqueness: { scope: :soccer_equipment_id }
end
