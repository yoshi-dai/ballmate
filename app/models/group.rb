class Group < ApplicationRecord
  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users
  has_many :matchings, dependent: :destroy

  validates :name, presence: true, length: { maximum: 255 }
end
