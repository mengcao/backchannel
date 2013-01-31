class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :votable_id
      t.string :votable_type
      t.references :user

      t.timestamps
    end
    add_index :votes, :user_id
    add_index :votes, [:votable_id,:votable_type]
  end
end
