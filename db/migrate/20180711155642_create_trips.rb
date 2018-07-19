class CreateTrips < ActiveRecord::Migration[5.2]
  def change
    create_table :trips do |t|
      t.datetime :departure_time
      t.datetime :arrival_time
      t.integer :number_of_tickets
      t.references :transfer, foreign_key: true

      t.timestamps
    end
  end
end
