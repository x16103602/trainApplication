class AddColumnsToLongtrains < ActiveRecord::Migration[5.1]
  def change
    add_column :longtrains, :cost, :integer
    add_column :longtrains, :detail, :string
  end
end
