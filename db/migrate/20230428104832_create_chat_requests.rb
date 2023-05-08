class CreateChatRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :chat_requests do |t|
      t.references :sender, null: false, foreign_key: { to_table: :users }
      t.references :receiver, null: false, foreign_key: { to_table: :users }
      t.references :matching, null: false, foreign_key: true
      t.integer :status, null: false

      t.timestamps
    end
  end
end
