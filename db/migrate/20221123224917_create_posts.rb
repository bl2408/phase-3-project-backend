class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.references :owner, foreign_key: { to_table: 'users', primary_key: "id"  }
      t.integer :viewable
      t.timestamps
    end

    # add_foreign_key :posts, :users, column: :owner_id
  end
end
