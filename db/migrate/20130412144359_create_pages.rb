class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.string :uri
      t.integer :popularity

      t.timestamps
    end
  end
end
