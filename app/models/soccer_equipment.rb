class SoccerEquipment < ApplicationRecord
  has_many :profile_soccer_equipments, dependent: :destroy
  has_many :user_profiles, through: :profile_soccer_equipments
end
