class LoadTypesFromDbpediaDb < ActiveRecord::Migration
  def up
    counter = 1
    File.open(File.join(Rails.root, "db", "instance_types_en.nt")).each_line do |line|
      matches = line.scan(/<[^>]*\/([^>]*)>/)

      if matches && !matches.empty?
        article = matches[0].first if matches[0] && matches[0].first
        type = matches[2].first if matches[2] && matches[2].first

        if article && type
          article.gsub!(/_/, ' ')

          begin
            pages = Page.search do
              fulltext article
              paginate :page => 1, :per_page => 1
            end.results
          rescue RSolr::Error::Http => e
            puts "record #{counter} is not saved with title of #{article} and type of #{type}"
            puts e.message
          end

          if pages && !pages.empty?
            page = pages.first
            if type && !type.empty?
              page.types << Type.find_or_create_by_name(type)
              puts "record #{counter} is saved with title of #{page.title} and type of #{type}"
              puts "=========================================================================="
              counter += 1
            end
          end
        end
      end
    end
  end

  def down
    Type.delete_all
    PagesType.delete_all
  end
end
