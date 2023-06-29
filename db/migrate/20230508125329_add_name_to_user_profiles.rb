class AddNameToUserProfiles < ActiveRecord::Migration[6.1]
  def change
    add_column :user_profiles, :name, :string, null: false
  end
end
