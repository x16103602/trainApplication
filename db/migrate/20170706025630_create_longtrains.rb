class CreateLongtrains < ActiveRecord::Migration[5.1]
  def change
    create_table :longtrains do |t|
      t.string :rtocken
      t.string :btocken
      t.string :category
      t.string :boarding
      t.string :destination
      t.string :location
      t.date :datetime
      t.integer :seat
      t.string :custID
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
