class CreateCinemaProgrammings < ActiveRecord::Migration[8.0]
  def change
    create_table :cinema_programmings do |t|
      t.string :name
      t.string :location
      t.string :movie_title
      t.text :showtimes

      t.timestamps
    end
  end
end
