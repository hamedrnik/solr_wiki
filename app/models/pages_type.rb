class PagesType < ActiveRecord::Base
  attr_accessible :page_id, :type_id

  belongs_to :page
  belongs_to :type
end
