class Group < ApplicationRecord
  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users
  has_one :matching, dependent: :destroy

  validates :name, presence: true, length: { maximum: 255 }

  def destroy_if_empty
    destroy if users.empty?
  end
end
