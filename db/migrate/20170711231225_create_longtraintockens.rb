class CreateLongtraintockens < ActiveRecord::Migration[5.1]
  def change
    create_table :longtraintockens do |t|
      t.string :rtocken
      t.string :userauth

      t.timestamps
    end
  end
end
