class CreateUserProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :user_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :favorite_player
      t.string :position
      t.string :role_in_team
      t.string :image
      t.integer :age
      t.string :favorite_place
      t.string :active_area
      t.string :equipment
      t.string :available_day_of_week
      t.string :available_time

      t.timestamps
    end
  end
end
