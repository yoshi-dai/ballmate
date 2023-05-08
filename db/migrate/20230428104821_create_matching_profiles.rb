class CreateMatchingProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :matching_profiles do |t|
      t.references :matching, null: false, foreign_key: true
      t.string :activity_content
      t.string :activity_detail
      t.string :recruitment_content
      t.string :short_message
      t.string :image

      t.timestamps
    end
  end
end
