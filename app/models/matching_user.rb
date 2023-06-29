class MatchingUser < ApplicationRecord
  belongs_to :matching
  belongs_to :user

  validates :user_id, uniqueness: { scope: :matching_id }
end
