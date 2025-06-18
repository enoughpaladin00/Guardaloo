class AddTimestampsToComments < ActiveRecord::Migration[6.1]
  def change
    change_column_null :comments, :created_at, false, Time.current
    change_column_null :comments, :updated_at, false, Time.current
  end
end
