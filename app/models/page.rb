class Page < ActiveRecord::Base
  attr_accessible :popularity, :title, :uri, :type_names

  has_many :types, through: :pages_types
  has_many :pages_types, dependent: :destroy

  attr_reader :type_names

  def type_names=(tokens)
    types_array = tokens.split(",")
    self.types.clear
    types_array.each do |type|
      found_type = Type.find_by_name(type.strip)
      if !found_type.blank?
        self.types << found_type if !self.types.include?(found_type)
      else
        self.types << Type.create!(name: type.strip) if type.strip.size != 0
      end
    end
  end

  validates_uniqueness_of :title, :uri
  validates_presence_of :title, :uri, :popularity

#  searchable do
#    text :title, as: "title_textp", stored: true
#    integer :popularity
#    integer :type_ids, multiple: true
#  end
end
