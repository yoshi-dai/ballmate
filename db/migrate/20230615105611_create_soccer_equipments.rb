class CreateSoccerEquipments < ActiveRecord::Migration[6.1]
  def change
    create_table :soccer_equipments do |t|
      t.string :name

      t.timestamps
    end
  end
end
