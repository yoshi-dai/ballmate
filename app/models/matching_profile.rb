class MatchingProfile < ApplicationRecord
  mount_uploader :image, MatchingImageUploader
  belongs_to :matching
end
