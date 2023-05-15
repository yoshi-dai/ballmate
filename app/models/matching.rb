class Matching < ApplicationRecord
  belongs_to :group

  has_many :matching_users
  has_many :users, through: :matching_users

  has_many :chat_requests, dependent: :destroy
  has_many :requested_users, through: :chat_requests, source: :user  

end
