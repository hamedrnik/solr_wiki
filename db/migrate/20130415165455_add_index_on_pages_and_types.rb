class AddIndexOnPagesAndTypes < ActiveRecord::Migration
  def up
    add_index :pages, :popularity
    add_index :pages_types, :type_id
    add_index :pages_types, :page_id
  end

  def down
    remove_index :pages, :popularity
    remove_index :pages_types, :type_id
    remove_index :pages_types, :page_id
  end
end
