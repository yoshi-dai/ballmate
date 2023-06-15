class RemoveEquipmentFromUserProfiles < ActiveRecord::Migration[6.1]
  def change
    remove_column :user_profiles, :equipment, :string
  end
end
