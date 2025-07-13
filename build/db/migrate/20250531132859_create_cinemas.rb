class CreateCinemas < ActiveRecord::Migration[8.0]
  def change
    create_table :cinemas do |t|
      t.string :name
      t.string :address
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
