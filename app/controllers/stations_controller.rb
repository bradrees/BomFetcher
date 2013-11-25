require 'open-uri'
require 'nokogiri'
require 'uri'

class StationsController < ApplicationController
  caches_action :all
  caches_action :images, expires_in: 1.minute

  def all
      @result = Array.new
      %w(WA NSW VIC QLD NT TAS SA).sort().each do |state|
        doc = Nokogiri::HTML(open("http://www.bom.gov.au/australia/radar/#{state.downcase}_radar_sites_table.shtml"))
        currentState = State.new
        currentState.name = state
        @result << currentState
        currentStation = nil
        doc.css('table.generic tr').each do |row|
          row.css('td').each do |cell|
            anchor = cell.css('a').first
            content = cell.content.strip
            if anchor == nil && content.length > 4 #need a better check here
              currentStation = Location.new
              currentStation.name = content
              currentState.locations << currentStation
            elsif currentStation != nil && anchor != nil
              locationView = LocationView.new
              locationView.name = content
              locationView.code = /IDR(\d\d\w)\./.match(anchor['href'])[1] # Get code from url
              currentStation.views << locationView
            end

          end
        end
      end

      respond_to do |format|
        format.html # all.html.erb
        format.json { render :json => @result }
      end
  end

  def images
    station = request[:station]
    @result = RadarImages.new
    doc = Nokogiri::HTML(open("http://www.bom.gov.au/products/IDR#{station}.loop.shtml"))
    doc.css('script').each do |script|
      URI.extract(script.content, %w(http)).each do |uri|
        if uri.match /radar\/IDR#{Regexp.quote(station)}\.T\.(\d+)\.png/
            @result.radar_images.push(uri.to_s)
        end
      end

      if script.content.match /var type\s*=\s*"(\d)";/
        @result.legend_image = $1
      end

      if script.content.match /IDR(\d\d\w)\.observations\.(\d+)\.png/
        @result.map_station = $1
        @result.observation_layer = $2
      end
    end

    respond_to do |format|
      format.html # images.html.erb
      format.json { render :json => @result }
    end
  end
end


class State
  attr_accessor :name, :locations

  def initialize
    @locations = Array.new
  end
end

class Location
  attr_accessor :name, :views

  def initialize
    @views = Array.new
  end
end

class LocationView
  attr_accessor :name, :code
end

class RadarImages
  attr_accessor :radar_images, :map_station, :observation_layer, :legend_image

  def initialize
    @radar_images = Array.new
  end
end