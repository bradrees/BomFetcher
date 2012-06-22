require 'open-uri'
require 'nokogiri'

class StationsController < ApplicationController
  caches_page :all
  def all
      @result = Array.new
      ["WA", "NSW", "VIC", "QLD", "NT", "TAS", "SA" ].sort().each do |state|
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
        format.html # index.html.erb
        format.xml  { render :xml => @result }
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