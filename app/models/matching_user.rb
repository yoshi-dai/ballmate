class MatchingUser < ApplicationRecord
  belongs_to :matching
  belongs_to :user
end
