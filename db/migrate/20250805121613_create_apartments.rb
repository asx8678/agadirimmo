class CreateApartments < ActiveRecord::Migration[8.0]
  def change
    create_table :apartments do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.decimal :latitude
      t.decimal :longitude
      t.integer :price_cents
      t.integer :size_sqm
      t.integer :rooms
      t.string :address
      t.string :city
      t.string :country
      t.integer :floor
      t.integer :year_built
      t.text :amenities
      t.string :status
      t.date :available_from

      t.timestamps
    end
  end
end
