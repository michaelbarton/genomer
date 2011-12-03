require 'unindent'

class Genomer::Runtime

  attr :command
  attr :arguments
  attr :flags

  def initialize(settings)
    @command   = settings.rest.shift
    @arguments = settings.rest
    @flags     = settings
  end

  def execute!
    case command
    when nil    then short_help
    when "help" then help
    when "init" then init
    else             run_plugin
    end
  end

  def short_help
    msg =<<-EOF
      genomer COMMAND [options]
      run `genomer help` for a list of available commands
    EOF
    msg.unindent
  end

  def help
    msg =<<-EOF
      genomer COMMAND [options]

      Available commands:
        init        Create a new genomer project
    EOF
    msg.unindent!

    msg << Genomer::Plugin.plugins.inject(String.new) do |str,p|
      str << '  '
      str << p.name.gsub("genomer-plugin-","").ljust(12)
      str << p.summary
      str << "\n"
    end
    msg.strip
  end

  def init
    project_name = arguments.first
    if File.exists?(project_name)
      raise GenomerError, "Directory '#{project_name}' already exists."
    else
      Dir.mkdir project_name
      Dir.mkdir File.join(project_name,'assembly')
    end
  end

  def run_plugin
    Genomer::Plugin[command].new(arguments,flags).run
  end

end
