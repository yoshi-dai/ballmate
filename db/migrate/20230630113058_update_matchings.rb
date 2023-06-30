class UpdateMatchings < ActiveRecord::Migration[6.1]
  def change
    remove_column :matchings, :time_zone, :string
    add_column :matchings, :scheduled_time, :time
  end
end
