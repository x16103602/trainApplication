class AddColumnsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :admin, :boolean
    add_column :users, :checker, :boolean
  end
end
