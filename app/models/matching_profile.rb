class MatchingProfile < ApplicationRecord
  mount_uploader :image, MatchingImageUploader
  belongs_to :matching

  def self.ransackable_attributes(auth_object = nil)
    ['activity_content', 'activity_detail', 'recruitment_content', 'short_message']
  end

  def self.ransackable_associations(auth_object = nil)
    ['matching'] # 検索可能な関連のリストを定義する
  end
end
