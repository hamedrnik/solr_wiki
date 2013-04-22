class LoadTypesFromDbpediaDb < ActiveRecord::Migration
  require 'rdf'
  require 'rdf/ntriples'

  def up
    counter = 1
    RDF::Reader.open(File.join(Rails.root, "db", "instance_types_en.nt")) do |reader|
      reader.each_statement do |statement|
        article = statement.subject.to_s.scan(/http:\/\/.*\/(.*)/).first.first
        type = statement.object.to_s.scan(/http:\/\/.*\/(.*)/).first.first
        article.gsub!(/_/, ' ') if article
        pages = Page.search { fulltext article }.results
        unless pages.empty?
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

  def down
    Type.delete_all
    PagesType.delete_all
  end
end
