class CreateViewables < ActiveRecord::Migration[6.1]
  def change
    create_table :viewables do |t|
      t.string :name
    end
  end
end
