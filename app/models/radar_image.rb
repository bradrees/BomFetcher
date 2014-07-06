class RadarImage
  include Mongoid::Document

  field :url, type: String
  field :observation_url, type: String

  field :translation_x, type: Integer
  field :translation_y, type: Integer
  #field :rotation_deg, type: Integer
  #field :rotation_x, type: Integer
  #feidl :rotation_y, type: Integer

  belongs_to :location_view


  #attr_accessor :radar_images, :map_station, :observation_layer, :legend_image, :lat, :lon, :km
end