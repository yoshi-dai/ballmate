class AddMatchingIdToNotifications < ActiveRecord::Migration[6.1]
  def change
    add_reference :notifications, :matching, foreign_key: true 
  end
end
