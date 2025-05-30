class CreateCinemas < ActiveRecord::Migration[8.0]
  def change
    create_table :cinemas do |t|
      t.string :tamburino_id
      t.string :name
      t.string :address
      t.string :town
      t.string :province
      t.string :phone
      t.string :lat
      t.string :lon

      t.timestamps
    end
  end
end
