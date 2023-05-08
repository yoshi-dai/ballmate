class Message < ApplicationRecord
  belongs_to :matching
  belongs_to :user
end
