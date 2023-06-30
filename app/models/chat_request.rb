class ChatRequest < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User', optional: true
  belongs_to :matching, optional: true

  validates :sender_id, presence: true, uniqueness: { scope: :receiver_id }, if: -> { receiver_id.present? }
  validates :receiver_id, uniqueness: { scope: :sender_id }, if: -> { receiver_id.present? }
  validates :matching_id, uniqueness: { scope: :sender_id }, if: -> { matching_id.present? }
  validates :status, presence: true

  enum status: { pending: 0, approved: 1, rejected: 2 }
end
