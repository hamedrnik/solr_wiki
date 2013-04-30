class LoadTypesFromDbpediaDb < ActiveRecord::Migration
  require 'rdf'
  require 'rdf/ntriples'

  def up
    counter_row = 1
    counter = 1
    RDF::Reader.open(File.join(Rails.root, "db", "instance_types_en.nt")) do |reader|
      reader.each_statement do |statement|
        begin
          puts "row #{counter_row}"
          counter_row += 1

          if statement && statement.subject && statement.object
            article = statement.subject.to_s.scan(/http:\/\/.*\/(.*)/).first.first
            type = statement.object.to_s.scan(/http:\/\/.*\/(.*)/).first.first

            if article && type
              article.gsub!(/_/, ' ')

              begin
                pages = Page.search do
                  fulltext "\"#{article}\""
                  paginate :page => 1, :per_page => 1
                end.results
              rescue RSolr::Error::Http => e
                puts "record #{counter} is not saved with title of #{article} and type of #{type}"
                puts e.message
              end

              if pages && !pages.empty?
                page = pages.first
                if page.title == article && type && !type.empty?
                  begin
                    page.types << Type.find_or_create_by_name(type)
                    puts "record #{counter} is saved with title of #{page.title} and type of #{type}"
                    puts "=========================================================================="
                    counter += 1
                  rescue ActiveRecord::RecordInvalid => invalid
                    puts invalid.record.errors.messages
                  end
                end
              end
            end
          end
        rescue
          puts 'An error occured'
        end
      end
    end
  end

  def down
    Type.delete_all
    PagesType.delete_all
  end
end
