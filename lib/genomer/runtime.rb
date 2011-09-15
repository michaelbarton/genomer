class Genomer::Runtime

  def initialize(settings)
    @settings = settings
  end

  def execute!
    _, project_name = @settings.rest

    if File.exists?(project_name)
      raise GenomerError, "Directory '#{project_name}' already exists."
    else
      Dir.mkdir project_name
    end
  end

end
