require 'unindent'
require 'tempfile'
require 'ronn/index'
require 'ronn/document'

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
    when "man"  then man
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
        man         View man page for the specified plugin
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

  def man
    if plugin = arguments.shift
      man_file_location = man_file(plugin)
      Kernel.exec "man #{groffed_man_file(man_file_location).path}"
    else
      msg =<<-EOF
        genomer man COMMAND
        run `genomer help` for a list of available commands
      EOF
      msg.unindent!
      msg.strip
    end
  end

  def man_file(plugin)
    File.join(Genomer::Plugin.fetch(plugin).full_gem_path, 'man', "genomer-#{plugin}.ronn")
  end

  def groffed_man_file(original_man_file)
    converted_man = Tempfile.new("genome-manpage-")
    File.open(converted_man.path,'w') do |out|
      out.puts Ronn::Document.new(original_man_file).convert('roff')
    end
    converted_man
  end

  def init
    project_name = arguments.first
    if File.exists?(project_name)
      raise Genomer::Error, "Directory '#{project_name}' already exists."
    else
      Dir.mkdir project_name
      Dir.mkdir File.join(project_name,'assembly')
    end
  end

  def run_plugin
    Genomer::Plugin[command].new(arguments,flags).run
  end

end
