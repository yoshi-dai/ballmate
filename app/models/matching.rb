class Matching < ApplicationRecord
  belongs_to :group
  has_many :users, through: :chat_requests
  has_many :messages, dependent: :destroy

end
