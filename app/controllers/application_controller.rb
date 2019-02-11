class ApplicationController < ActionController::API
  include JsonHandler
  include ExceptionHandler

  before_action :set_parent_chain
  before_action :set_resource, only: [:show, :update, :destroy]

  def index
    if has_parents?
      children_method = model.to_s.underscore.pluralize
      @resources = @parent_chain.send(children_method)
    else
      @resources = model.all
    end
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
    @resource.update!(resource_params)
    head :no_content
  end

  def destroy
    @resource.destroy
    head :no_content
  end

  private

  class << self
    def has_parents *parents
      @parents = *parents.map { |p| p.to_s.camelize.constantize }
    end

    def permit_params *whitelist
      @permitted_params = *whitelist
    end
  end

  def model
    self.class.to_s.chomp("Controller").singularize.constantize
  end

  def parents
    self.class.instance_variable_get(:@parents)
  end

  def has_parents?
    parents.present?
  end

  def permitted_params
    pparams = self.class.instance_variable_get(:@permitted_params)
    pparams << @parent_id_key if has_parents?

    pparams
  end

  def set_parent_chain
    return unless has_parents?

    @parent_chain = nil

    parents.each do |parent|
      @parent_id_key = (parent.to_s.underscore + "_id").to_sym
      parent_id = params[@parent_id_key]

      if @parent_chain.nil?
        @parent_chain = parent.find parent_id
      else
        children_method = parent.to_s.pluralize
        @parent_chain = @parent_chain.send(children_method).find(parent_id)
      end
    end
  end

  def set_resource
    if has_parents?
      children_method = model.to_s.underscore.pluralize
      @resource = @parent_chain.send(children_method).find(params[:id])
    else
      @resource = model.find params[:id]
    end
  end

  def resource_params
    params.permit(*permitted_params)
  end
end
