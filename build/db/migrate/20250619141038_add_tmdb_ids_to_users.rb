class AddTmdbIdsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :tmdb_id_1, :integer
    add_column :users, :tmdb_id_2, :integer
    add_column :users, :tmdb_id_3, :integer
  end
end
