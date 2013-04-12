class CreatePagesTypes < ActiveRecord::Migration
  def change
    create_table :pages_types do |t|
      t.integer :type_id
      t.integer :page_id

      t.timestamps
    end
  end
end
