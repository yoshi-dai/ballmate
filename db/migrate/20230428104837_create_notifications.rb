class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :matching, null: false, foreign_key: true
      t.string :title
      t.text :content
      t.boolean :read
      t.datetime :read_at

      t.timestamps
    end
  end
end
