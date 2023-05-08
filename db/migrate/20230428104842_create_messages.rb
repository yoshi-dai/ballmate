class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.references :matching, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :type
      t.text :text
      t.string :image_url
      t.integer :sticker_id

      t.timestamps
    end
  end
end
