class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.string :name
      t.string :surname
      t.string :email

      t.references :user, foreign_key: true
      t.belongs_to :ticket, foreign_key: true

      t.timestamps
    end
  end
end
