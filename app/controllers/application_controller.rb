class ApplicationController < ActionController::API
  before_action :set_resource, only: [:show, :update, :destroy]

  def index
    @resources = model.all
    render_json(@resources)
  end

  def create
    @resource = model.create!(resource_params)
    render_json(@resource, :created)
  end

  def show
    render_json(@resource)
  end

  def update
    @resource.update(resource_params)
    head :no_content
  end

  def destroy
    @resource.destroy
    head :no_content
  end

  private

  class << self
    def whitelist_params *params
      @params_whitelist = *params
    end
  end

  def model
    @model ||= self.class.to_s.chomp("Controller").singularize.constantize
  end

  def set_resource
    @resource = model.find params[:id]
  end

  def params_whitelist
    self.class.instance_variable_get(:@params_whitelist)
  end

  def resource_params
    params.permit(*params_whitelist)
  end

  def render_json body, status=:ok
    render json: body, status: status
  end
end
