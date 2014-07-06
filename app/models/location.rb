class Location
  include Mongoid::Document

  field :name, type: String
  field :lat, type: Float
  field :lon, type: Float

  belongs_to :region
  has_many :location_views
end