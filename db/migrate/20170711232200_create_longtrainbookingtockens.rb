class CreateLongtrainbookingtockens < ActiveRecord::Migration[5.1]
  def change
    create_table :longtrainbookingtockens do |t|
      t.string :btocken
      t.string :userauth

      t.timestamps
    end
  end
end
