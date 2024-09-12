class SessionsController < ApplicationController
  skip_before_action :authenticate

  def login
    token = ::AuthenticationService.new(email: params[:email], password: params[:password]).call

    if token.present?
      render json: { token: token }
    else
      render json: { error: "Alguma coisa está errada com suas credenciais" }, status: 401
    end
  end

  def signup
    user = User.new(user_params)

    if user.save
      token = ::JsonWebToken.encode({ user_id: user.id })

      render json: { token: token }
    else
      render json: { message: "Não foi possível criar seu perfil" }, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end