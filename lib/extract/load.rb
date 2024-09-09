require 'extract/data/ibge'
require 'extract/data/rest_countries'

module Extract
  class Load
    def self.call
      pp "Loading data from the IBGE API"
      countries_data = Extract::Data::Ibge.load
      
      pp "Loading data from the RestCountries API"
      rest_countries_data = Extract::Data::RestCountries.load

      countries_data.each do |country_data|
        rest_data = rest_countries_data.find do |data|
          data[:identifier] == country_data[:identifier]
        end

        country_data.merge!(rest_data)
      end
    end
  end
end