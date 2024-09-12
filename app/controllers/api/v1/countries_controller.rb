module Api
  module V1
    class CountriesController < ApplicationController
      before_action :set_country, only: %i[show update destroy]

      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
      rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid

      # GET /api/v1/countries
      def index
        @countries = Country.all
        render json: { data: CountrySerializer.new(@countries).json }
      end
    
      # GET /api/v1/countries/1
      def show
        render json: @country
      end
    
       # POST /api/v1/countries/
      def create
        @country = Country.new(country_params)

        if @country.save!
          render json: @country, status: :created, location: api_v1_countries_path(@country)
        end
      end
    
      # PATCH/PUT /api/v1/countries/1
      def update
        if @country.update!(country_params)
          render json: @country
        end
      end
    
      # DELETE /api/v1/countries/1
      def destroy
        @country.destroy
        head :no_content
      end
      
      private
    
      def set_country
        @country = Country.find(params[:id])
      end
    
      def country_params
        params.require(:country).permit(:name, :identifier, :area, :location, :languages, :capital,
                                        :latitude, :longitude, :population, :currency_units, :timezones,
                                        :osm_code, :history)
      end

      def search_param
        params.fetch(:q, '*')
      end
    
      def render_not_found_response
        render json: { error: "País não encontrado" }, status: :not_found
      end

      def render_record_invalid(invalid)
        render json: { errors: invalid.record.errors.full_messages }, status: 422
      end
    end
  end
end
