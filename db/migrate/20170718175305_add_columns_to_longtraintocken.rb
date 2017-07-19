class AddColumnsToLongtraintocken < ActiveRecord::Migration[5.1]
  def change
    add_column :longtraintockens, :to, :string
    add_column :longtraintockens, :from, :string
    add_column :longtraintockens, :counter, :integer
  end
end
