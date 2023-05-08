class ChatRequest < ApplicationRecord
  belongs_to :sender
  belongs_to :receiver
  belongs_to :matching
end
