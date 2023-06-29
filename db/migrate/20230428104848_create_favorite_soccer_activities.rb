class CreateFavoriteSoccerActivities < ActiveRecord::Migration[6.1]
  def change
    create_table :favorite_soccer_activities do |t|
      t.string :soccer_type

      t.timestamps null: false
    end
  end
end
