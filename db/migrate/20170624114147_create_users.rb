class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :provider
      t.string :userid
      t.string :name

      t.timestamps
    end
  end
end
