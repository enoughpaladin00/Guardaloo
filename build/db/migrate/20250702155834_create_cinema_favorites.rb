class CreateCinemaFavorites < ActiveRecord::Migration[8.0]
  def change
    create_table :cinema_favorites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :cinemasdef, null: false, foreign_key: { to_table: :cinemasdef } 

      t.timestamps
    end
  end
end
