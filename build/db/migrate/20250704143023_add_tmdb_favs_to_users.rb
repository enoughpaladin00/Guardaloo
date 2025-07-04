class AddTmdbFavsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :tmdb_fav1, :integer
    add_column :users, :tmdb_fav2, :integer
    add_column :users, :tmdb_fav3, :integer
  end
end
