class RemoveActiveStorageTables < ActiveRecord::Migration[8.0]
  def change
    drop_table :active_storage_tables, if_exists: true
  end
end
