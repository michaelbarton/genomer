class Genomer::Runtime

  def initialize(settings)
    @settings = settings
  end

  def execute!
    _, project_name = @settings.rest
    Dir.mkdir project_name
  end

end
