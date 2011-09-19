require 'unindent'

class Genomer::Runtime

  def initialize(settings)
    @settings = settings
  end

  def execute!
    command = @settings.rest.shift
    case command
    when nil    then short_help
    when "init" then init(@settings.rest.shift)
    end
  end

  def short_help
    msg =<<-EOF
      genomer COMMAND [options]
      run `genomer help` for a list of available commands`
    EOF
    msg.unindent
  end

  def init(project_name)
    if File.exists?(project_name)
      raise GenomerError, "Directory '#{project_name}' already exists."
    else
      Dir.mkdir project_name
    end
  end

end
