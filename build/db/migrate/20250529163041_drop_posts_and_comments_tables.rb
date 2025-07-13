class DropPostsAndCommentsTables < ActiveRecord::Migration[6.1]
  def up
    drop_table :comments if table_exists?(:comments)
    drop_table :posts if table_exists?(:posts)
  end

  def down
    # Non implementiamo il down perché vogliamo ricreare le tabelle con nuove migrazioni
    raise ActiveRecord::IrreversibleMigration
  end
end
