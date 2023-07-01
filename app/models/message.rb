class Message < ApplicationRecord
  belongs_to :matching
  belongs_to :user

  validates :text, presence: true, length: { maximum: 1000 }

  after_create_commit { MessageBroadcastJob.perform_later(self) }
end
