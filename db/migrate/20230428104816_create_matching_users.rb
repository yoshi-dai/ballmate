class CreateMatchingUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :matching_users do |t|
      t.references :user, null: false, foreign_key: true
      t.references :matching, null: false, foreign_key: true

      t.timestamps
    end
  end
end
