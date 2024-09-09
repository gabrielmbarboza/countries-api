class ApplicationSerializer
  def initialize(resource)
    @resource = resource
  end

  def json(json_fields)
    @resource&.as_json(json_fields)
  end
end