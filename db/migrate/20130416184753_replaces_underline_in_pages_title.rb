class ReplacesUnderlineInPagesTitle < ActiveRecord::Migration
  def up
    @offset = 0
    @limit = 100
    @pages_count = (execute 'select count(*) from pages;').first.first.to_i

    while @offset <= @pages_count do
      @pages = (execute "select id, title from pages order by popularity desc limit #{@limit} offset #{@offset}")

      @pages.each_with_index do |p, i|
        page_id = p.first
        page_title = p[1].gsub(/_/, ' ')

        unless page_title == p[1]
          page_title = page_title.gsub(/\\/, '\&\&').gsub(/'/, "''")

          execute "update pages set title = '#{page_title}' where id = #{page_id}"
          puts "record #{@offset + 1 + i} is saved with title of #{page_title}"
        end
      end
      @offset += @limit
    end
  end

  def down
  end
end
