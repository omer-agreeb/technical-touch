# frozen_string_literal: true

class V1::BaseController < V1::ApiController
  before_action :find_resource, only: %i[show edit update destroy]
  ## ------------------------------------------------------------ ##

  # GET : /v1/{resource}
  def index
    yield scope if block_given?
    instance_variable_set("@#{resource_name}s", scope)
  end

  ## ------------------------------------------------------------ ##

  #GET : /v1/{resource}/new
  def new
    instance_variable_set("@#{resource_name}", scope)
  end

  ## ------------------------------------------------------------ ##

  # GET /v1/{resource}/:id/edit
  def edit
  end
  ## ------------------------------------------------------------ ##

  # GET : /v1/{resource}/:id
  def show
    return render_not_found if resource.nil?

    yield scope if block_given?
    instance_variable_set("@#{resource_name}", resource)
  end

  ## ------------------------------------------------------------ ##

  # POST : /v1/{resource}/:id
  def create
    find_resource(scope.new(params_processed))
    if resource.save
      yield resource if block_given?
      redirect_to send("#{resource_name}s_url"), notice: "#{resource_name} was successfully created."
    else
      render :new
    end
  end

  ## ------------------------------------------------------------ ##

  # PUT : /v1/{resource}/:id
  def update
    if resource.update(params_processed)
      redirect_to send("#{resource_name}_url"),
      notice: "#{resource_name} was successfully updated."
    else
      render :new 
    end
  end

  ## ------------------------------------------------------------ ##

  # DELETE : /v1/{resource}/:id
  def destroy
    if resource.destroy
      respond_to do |format|
        format.html { redirect_to send("#{resource_name}s_url"), notice: 'Test was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  ## ------------------------------------------------------------ ##

  private

  def scope
    scope_name = "#{resource_name.pluralize}_scope"
    @scope ||= send(scope_name)
  rescue NoMethodError
    resource_class
  end

  def find_resource(resource = nil)
    resource ||= scope.find(id_parameter)
    instance_variable_set("@#{resource_name}", resource)
  rescue ActiveRecord::RecordNotFound
    render_not_found
  end

  def resource
    instance_variable_get("@#{resource_name}")
  end

  def resource_class
    @resource_class ||= resource_name.classify.constantize
  end

  def resource_name
    @resource_name ||= controller_name.singularize
  end

  def resource_params
    @resource_params ||= send("#{resource_name}_params")
  end

  def params_processed
    resource_params
  end

  def id_parameter
    params[:id]
  end
end
