class CreateCinemaShowtimes < ActiveRecord::Migration[8.0]
  def change
    create_table :cinema_showtimes do |t|
      t.string :day
      t.string :movie
      t.string :show_type
      t.text :show_times

      t.timestamps
    end
  end
end
