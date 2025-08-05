class AddIndexesToApartments < ActiveRecord::Migration[8.0]
  def change
    add_index :apartments, :status
    add_index :apartments, :city
    add_index :users, :email, unique: true
  end
end
