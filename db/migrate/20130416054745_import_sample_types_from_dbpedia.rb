class ImportSampleTypesFromDbpedia < ActiveRecord::Migration
  def up
    @offset = 0
    @limit = 100
    @pages_count = Page.count

    while @offset <= @pages_count do
      @pages = Page.order('popularity desc').offset(@offset).limit(@limit)

      @pages.each_with_index do |p, i|
        results = Dbpedia.search(p.title)
        unless results.empty?
          types = results.first.classes.collect(&:label)
          if !types.empty?
            p.types = []
            types.each do |type|
              p.types << Type.find_or_create_by_name!(name: type)
            end
            p.title = p.title.gsub(/([\_])/, ' ')
            p.save!
            puts "record #{@offset + 1 + i} is saved with title of #{p.title}"
          end
        else
          p.title = p.title.gsub(/([\_])/, ' ')
          p.save!
          puts "#{p.title} is not found in Dbpedia"
        end
      end

      @offset += @limit
    end
  end

  def down
  end
end
