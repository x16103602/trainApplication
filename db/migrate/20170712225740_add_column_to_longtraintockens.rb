class AddColumnToLongtraintockens < ActiveRecord::Migration[5.1]
  def change
    add_column :longtraintockens, :seatcounter, :integer
  end
end
