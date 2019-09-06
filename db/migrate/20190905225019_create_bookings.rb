class CreateBookings < ActiveRecord::Migration[5.2]
  def change
    create_table :bookings do |t|
      t.references :account, foreign_key: true
      t.references :expert, foreign_key: true
      t.datetime :start
      t.integer :minutes
      t.string :access_code

      t.timestamps
    end
  end
end
