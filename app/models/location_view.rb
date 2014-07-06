class LocationView
  include Mongoid::Document

  field :name, type: String
  field :code, type: String
  field :observation_code, type: String
  field :km, type: Integer
  field :legend_image, type: Integer

  belongs_to :location
  embeds_many :radar_images
end