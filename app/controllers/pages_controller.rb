class PagesController < ApplicationController
  # GET /pages
  # GET /pages.json
  def index
    solr = RSolr.connect :url => 'http://ec2-54-234-109-21.compute-1.amazonaws.com:8080/solr/collection1'
    results = solr.get 'select', params: {
      q: search_query,
      start: params[:page].to_i - 1,
      rows: 10,
      hl: true,
      "hl.fl" => 'title',
      sort: 'popularity desc',
      fl: 'title',
      "hl.simple.pre" => "<b>",
      "hl.simple.post" => "</b>"
    }

    @pages = []
    results["highlighting"].each do |key, value|
      page = {}
      page["title"] = key
      page["highlight"] = value["title"].first
      @pages << page
    end

#    if params[:term_search]
#      search = Page.search do
#        fulltext params[:term_search] do
#          highlight :title
#        end
#        unless params[:type_id].empty?
#          with :type_ids, params[:type_id]
#        end
#        order_by :popularity, :desc
#        paginate :page => params[:page], :per_page => 10
#      end

#      @pages = []
#      search.each_hit_with_result do |hit, result|
#        hit.highlights(:title).each do |highlight|
#          result.title = highlight.format{ |word| "<b>#{word}</b>"}
#        end
#        @pages << result
#      end
#    else
#      @pages = Page.order("popularity desc").page(params[:page]).per(30)
#    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pages }
    end
  end

  def search
    @desc = Dbpedia.search(params[:term_search]).first.description

    respond_to do |format|
      format.js
    end
  end

  # GET /pages/1
  # GET /pages/1.json
  def show
    @page = Page.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @page }
    end
  end

  # GET /pages/new
  # GET /pages/new.json
  def new
    @page = Page.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @page }
    end
  end

  # GET /pages/1/edit
  def edit
    @page = Page.find(params[:id])
  end

  # POST /pages
  # POST /pages.json
  def create
    @page = Page.new(params[:page])

    respond_to do |format|
      if @page.save
        format.html { redirect_to @page, notice: 'Page was successfully created.' }
        format.json { render json: @page, status: :created, location: @page }
      else
        format.html { render action: "new" }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pages/1
  # PUT /pages/1.json
  def update
    @page = Page.find(params[:id])

    respond_to do |format|
      if @page.update_attributes(params[:page])
        format.html { redirect_to @page, notice: 'Page was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy
    @page = Page.find(params[:id])
    @page.destroy

    respond_to do |format|
      format.html { redirect_to pages_url }
      format.json { head :no_content }
    end
  end

  private

  def search_query
    if params[:type_id] and !params[:type_id].empty?
      "title:\"#{params[:term_search]}\" AND types:\"#{params[:type_id]}\""
    else
      "title:\"#{params[:term_search]}\""
    end
  end
end
