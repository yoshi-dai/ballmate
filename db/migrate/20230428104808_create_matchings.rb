class CreateMatchings < ActiveRecord::Migration[6.1]
  def change
    create_table :matchings do |t|
      t.string :name, null: false
      t.date :date
      t.string :time_zone
      t.string :place
      t.boolean :public_flag
      
      t.timestamps null: false
    end
  end
end
