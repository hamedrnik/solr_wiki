class ImportSampleTypesFromDbpedia < ActiveRecord::Migration
  def up
    Page.all.each_with_index do |p, i|
      types = Dbpedia.search(p.title).first.classes.collect(&:label)
      if !types.empty?
        p.types = []
        types.each do |type|
          p.types << Type.find_or_create_by_name!(name: type)
        end
        p.title = p.title.gsub(/([\_])/, ' ')
        p.save!
        puts "record #{i} is saved with title of #{p.title}"
      end
    end
  end

  def down
  end
end
