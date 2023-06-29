class CreateProfileSoccerEquipments < ActiveRecord::Migration[6.1]
  def change
    create_table :profile_soccer_equipments do |t|
      t.references :user_profile, null: false, foreign_key: true
      t.references :soccer_equipment, null: false, foreign_key: true

      t.timestamps null: false
    end
  end
end
