class AddMovieFieldsToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :movie_id, :integer
    add_column :posts, :movie_title, :string
    add_column :posts, :movie_poster_path, :string
  end
end
