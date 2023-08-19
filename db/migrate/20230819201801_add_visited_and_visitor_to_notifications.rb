class AddVisitedAndVisitorToNotifications < ActiveRecord::Migration[6.1]
  def change
    add_reference :notifications, :visitor, null: false, foreign_key: { to_table: :users }
    add_reference :notifications, :visited, foreign_key: { to_table: :users }
    add_column :notifications, :action, :string, default: '', null: false
    add_column :notifications, :checked, :boolean, default: false, null: false

    remove_reference :notifications, :user, null: false, foreign_key: true
    remove_column :notifications, :title, :string
    remove_column :notifications, :content, :string
    remove_reference :notifications, :matching, null: false, foreign_key: true
    remove_column :notifications, :read, :boolean
    remove_column :notifications, :read_at, :datetime
  end
end
