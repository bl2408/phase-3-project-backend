class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      # t.references :owner, foreign_key: { to_table: 'users', primary_key: "id"  }
      t.integer :viewable_id
      t.timestamps
    end
  end
end
