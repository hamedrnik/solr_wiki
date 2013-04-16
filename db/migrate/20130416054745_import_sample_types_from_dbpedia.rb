class ImportSampleTypesFromDbpedia < ActiveRecord::Migration
  def up
    @offset = 0
    @limit = 100
    @pages_count = (execute 'select count(*) from pages;').first.first.to_i

    while @offset <= @pages_count do
      @pages = (execute "select id, title from pages order by popularity desc limit #{@limit} offset #{@offset}")

      @pages.each_with_index do |p, i|
        page_id = p.first
        page_title = p[1].gsub(/_/, ' ')
        page_title = page_title.gsub(/\\/, '\&\&').gsub(/'/, "''")

        results = Dbpedia.search(p[1])
        unless results.empty?
          types = results.first.classes.collect(&:label)
          if !types.empty?
            # deletes old types of page
            execute "delete from pages_types where page_id = #{page_id}"

            types.each do |type|
              escaped_type = type.gsub(/\\/, '\&\&').gsub(/'/, "''")

              @types = execute "select id from types where name like '#{escaped_type}'"
              if @types.count > 0
                execute "insert into pages_types (type_id, page_id, created_at, updated_at) values (#{@types.first.first}, #{page_id}, '#{Time.zone.now}', '#{Time.zone.now}')"
              else
                execute "insert into types (name, created_at, updated_at) values ('#{escaped_type}', '#{Time.zone.now}', '#{Time.zone.now}')"
                new_type = Type.find_by_name(type)
                execute "insert into pages_types (type_id, page_id, created_at, updated_at) values (#{new_type.id}, #{page_id}, '#{Time.zone.now}', '#{Time.zone.now}')"
              end
            end

            # updates title
            execute "update pages set title = '#{page_title}' where id = #{page_id}"
            puts "record #{@offset + 1 + i} is saved with title of #{page_title}"
          end
        else
          execute "update pages set title = '#{page_title}' where id = #{page_id}"
          puts "#{page_title} is not found in Dbpedia"
        end
      end

      @offset += @limit
    end
  end

  def down
  end
end
