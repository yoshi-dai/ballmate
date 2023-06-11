class Message < ApplicationRecord
  belongs_to :matching
  belongs_to :user

  validates :text, presence: true
  after_create_commit { MessageBroadcastJob.perform_later self }
end
