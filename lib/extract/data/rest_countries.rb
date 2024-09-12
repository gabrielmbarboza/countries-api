require 'net/http'

module Extract
  module Data
    class RestCountries
      def self.load
        rest_countries_uri = URI('https://restcountries.com/v3.1/independent?&fields=cca2,latlng,population,maps,timezones')

        begin
          rest_countries_response = Net::HTTP.get_response(rest_countries_uri)
    
          unless rest_countries_response.is_a?(Net::HTTPSuccess)
            Rails.logger.error("Rest Countries returned an error: #{rest_countries_response.message} [#{rest_countries_response.code}]")
            return
          end
    
          rest_countries = JSON.parse(rest_countries_response.body)
    
          rest_countries.map do |country|
            {
              identifier: country["cca2"],
              latitude: country["latlng"].first,
              longitude: country["latlng"].last,
              osm_code: country["maps"]["openStreetMaps"].split('/').last,
              population: country["population"],
              timezones: country["timezones"].join(",")
            }
          end
        rescue StandardError => e
          Rails.logger.error(e.message)
          nil
        end
      end
    end
  end
end