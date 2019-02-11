class AuthenticationController < ActionController::API
  include JsonHandler

  def authenticate
    user = User.find_by_name(params[:name])
    if user && user.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render_json({ auth_token: token })
    else
      render_json({ error: "invalid credentials" }, :unauthorized)
    end
  end
end
