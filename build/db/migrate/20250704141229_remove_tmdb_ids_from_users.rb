class RemoveTmdbIdsFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :tmdb_id_1, :integer
    remove_column :users, :tmdb_id_2, :integer
    remove_column :users, :tmdb_id_3, :integer
  end
end
