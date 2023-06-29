class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.references :matching, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :text
      
      t.timestamps null: false
    end
  end
end
