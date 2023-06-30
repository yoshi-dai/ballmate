class MatchingProfile < ApplicationRecord
  mount_uploader :image, MatchingImageUploader
  belongs_to :matching

  validates :activity_content, length: { maximum: 255}
  validates :activity_detail, length: { maximum: 255 }
  validates :recruitment_content, length: { maximum: 255 }
  validates :short_message, length: { maximum: 255 }

  def self.ransackable_attributes(_auth_object = nil)
    ['activity_content', 'activity_detail', 'recruitment_content', 'short_message']
  end

  def self.ransackable_associations(_auth_object = nil)
    ['matching'] # 検索可能な関連のリストを定義する
  end
end
