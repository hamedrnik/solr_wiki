class Type < ActiveRecord::Base
  attr_accessible :name

  has_many :pages, through: :pages_types
  has_many :pages_types, dependent: :destroy

#  searchable do
#    text :name, as: "name_textp"
#    time :created_at
#  end
end
