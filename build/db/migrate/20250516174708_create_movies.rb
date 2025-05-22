class CreateMovies < ActiveRecord::Migration[8.0]
  def change
    create_table :movies do |t|
      t.integer :tmdb_id
      t.string :title
      t.date :release_date
      t.text :overview

      t.timestamps
    end
  end
end
