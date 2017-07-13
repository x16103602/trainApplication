class CreateTickets < ActiveRecord::Migration[5.1]
  def change
    create_table :tickets do |t|
      t.string :name
      t.integer :age
      t.integer :aticket
      t.integer :cticket
      t.string :tfrom
      t.string :tto
      t.string :tclass
      t.string :treturn
      t.string :tvhour
      t.string :tvdate
      t.string :proof
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
