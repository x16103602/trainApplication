class AddColumnToTicket < ActiveRecord::Migration[5.1]
  def change
    add_column :tickets, :price, :integer
  end
end
