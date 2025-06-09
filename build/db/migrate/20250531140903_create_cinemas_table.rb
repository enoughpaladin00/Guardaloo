class CreateCinemasTable < ActiveRecord::Migration[7.0]
  def change
    create_table :cinemas do |t|
      t.string :name, null: false
      t.string :address, null: false
      t.float :latitude
      t.float :longitude
      t.timestamps
    end
    
    add_index :cinemas, :name, unique: true
  end
end