class ApplicationController < ActionController::API
  before_action :authenticate

  private

  def authenticate
    header = request.headers['Authorization']
    token = header.split(' ').last if header.present?

    begin
      decode_data = ::JsonWebToken.decode(token)
      user_id = decode_data[0]["user_id"]

      @current_user = User.find(user_id)
    rescue ActiveRecord::RecordNotFound => e
      render json: { message: e.message, status: :unauthorized }
    rescue StandardError => e
      render json: { message: e.message, status: :unauthorized }
    end
  end
end
