class StaticPagesController < ApplicationController
  def home
    solr = RSolr.connect :url => 'http://ec2-54-234-109-21.compute-1.amazonaws.com:8080/solr/collection1'
    results = solr.get 'select', params: {
      facet: true,
      "facet.field" => "types"
    }
    @types = results["facet_counts"]["facet_fields"]["types"].even_values

    respond_to do |format|
      format.html
    end
  end
end

class Array
  def odd_values
    self.values_at(* self.each_index.select {|i| i.odd?})
  end
  def even_values
    self.values_at(* self.each_index.select {|i| i.even?})
  end
end
