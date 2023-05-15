class AddImageCacheToUserProfiles < ActiveRecord::Migration[6.1]
  def change
    add_column :user_profiles, :image_cache, :string
  end
end
