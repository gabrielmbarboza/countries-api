class AuthenticationService
  def initialize(email:, password:)
    @email = email
    @password = password
  end

  def call
    user = User.find_by(email: @email)

    if user.present? && user.authenticate(@password)
      return ::JsonWebToken.encode({ user_id: user.id })
    end
  end
end