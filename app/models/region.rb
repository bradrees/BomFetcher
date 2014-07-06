class Region
  include Mongoid::Document

  field :name, type: String

  embeds_many :location
end
