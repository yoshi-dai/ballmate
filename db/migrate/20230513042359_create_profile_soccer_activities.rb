class CreateProfileSoccerActivities < ActiveRecord::Migration[6.1]
  def change
    create_table :profile_soccer_activities do |t|
      t.references :user_profile, null: false, foreign_key: true
      t.references :favorite_soccer_activity, null: false, foreign_key: true

      t.timestamps
    end
  end
end
