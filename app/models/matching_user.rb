class MatchingUser < ApplicationRecord
  belongs_to :user
  belongs_to :matching
end
