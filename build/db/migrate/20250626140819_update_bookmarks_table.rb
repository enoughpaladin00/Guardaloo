class UpdateBookmarksTable < ActiveRecord::Migration[8.0]
  def change

    add_column :bookmarks, :tmdb_id, :integer, null: false
    add_column :bookmarks, :title, :string
    add_column :bookmarks, :poster_path, :string

    add_index :bookmarks, [:user_id, :tmdb_id], unique: true
  end
end
