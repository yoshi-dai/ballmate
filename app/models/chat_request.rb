class ChatRequest < ApplicationRecord
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id', optional: true
  belongs_to :matching, optional: true

  enum status: { pending: 0, approved: 1, rejected: 2 }
end
