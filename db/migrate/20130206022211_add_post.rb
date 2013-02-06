class AddPost < ActiveRecord::Migration
  def up
    add_column :posts, :category_id, :integer
    add_index :posts,:category_id
  end

  def down
  end
end
