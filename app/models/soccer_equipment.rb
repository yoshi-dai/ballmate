class SoccerEquipment < ApplicationRecord
  has_many :profile_soccer_equipments, dependent: :destroy
  has_many :user_profiles, through: :profile_soccer_equipments

  validates :name, presence: true, length: { maximum: 255 }
end
