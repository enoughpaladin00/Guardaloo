class CreateFavorites < ActiveRecord::Migration[8.0]
  def change
    create_table :favorites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :cinemasdef, null: false, foreign_key: {to_table: :cinemasdef }

      t.timestamps
    end
    add_index :favorites, [:user_id, :cinemasdef_id], unique:true
  end
end
