module Api
  module V1 
    class PaginationSerializer < ApplicationSerializer
      def json
        super(json_fields)
      end

      private

      def json_fields
        {
          only: %i[prev_url next_url count page next]
        }
      end
    end
  end
end