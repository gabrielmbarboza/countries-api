module Api
  module V1 
    class CountrySerializer < ApplicationSerializer
      def json
        super(json_fields)
      end

      private

      def json_fields
        {
          except: %i[id created_at updated_at]
        }
      end
    end
  end
end