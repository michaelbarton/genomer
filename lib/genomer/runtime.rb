require 'unindent'

class Genomer::Runtime

  def initialize(settings)
    @settings = settings
  end

  def execute!
    command = @settings.rest.shift
    case command
    when nil    then short_help
    when "help" then help
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

  def help
    msg =<<-EOF
      genomer COMMAND [options]

      Available commands:
    EOF
    msg.unindent!

    msg << plugins.inject(String.new) do |str,p|
      str << '  '
      str << p.name.gsub("genomer-plugin-","").ljust(12)
      str << p.summary
      str << "\n"
    end
    msg.strip
  end

  def init(project_name)
    if File.exists?(project_name)
      raise GenomerError, "Directory '#{project_name}' already exists."
    else
      Dir.mkdir project_name
      Dir.mkdir File.join(project_name,'.gnmr')
    end
  end

  def plugins
    require 'bundler'
    if File.exists?("Gemfile")
      bundle = Bundler.setup
      return bundle.gems.select do |gem|
        gem.name =~ /genomer-plugin-.+/
      end
    else
      Array.new
    end
  end

end
