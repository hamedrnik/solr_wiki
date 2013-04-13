class TypesController < ApplicationController
  def index
    @types = Type.search do
      fulltext params[:type_search]
      order_by :created_at, :desc
    end.results

    render json: @types
  end
end
