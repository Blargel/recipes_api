module JsonHandler
  def render_json body, status=:ok
    render json: body, status: status
  end
end
