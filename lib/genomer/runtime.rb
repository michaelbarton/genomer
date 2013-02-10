require 'unindent'
require 'tempfile'
require 'md2man'

require 'genomer/version'

class Genomer::Runtime

  attr :command
  attr :arguments
  attr :flags

  MESSAGES = {
    :error  => {
      :init_again =>
        "This directory contains a 'Gemfile' and already appears to be a genomer project."
  },
    :output => {
      :version => "Genomer version #{Genomer::VERSION}",
      :not_project =>
        "Use `genomer init NAME` to create a new genomer project called NAME",
      :simple_help =>
        "genomer COMMAND [options]\nrun `genomer help` for a list of available commands",
      :man =>
        "genomer man COMMAND\nrun `genomer help` for a list of available commands"
    }
  }


  def message(type,msg)
    content = MESSAGES[type][msg]
    type == :error ? raise(Genomer::Error, content) : content
  end


  def initialize(settings)
    @command   = settings.rest.shift
    @arguments = settings.rest
    @flags     = settings
  end

  def execute!
    return message :output, :version if flags[:version]

    if genomer_project?
      case command
      when nil    then message :output, :simple_help
      when "help" then help
      when "init" then message :error, :init_again
      when "man"  then man
      else             run_plugin
      end
    else
      case command
      when "init" then init
      else             message :output, :not_project
      end
    end
  end

  def help
    msg =<<-EOF
      genomer COMMAND [options]

      Available commands:
        init        Create a new genomer project
        man         View man page for the specified plugin
    EOF
    msg.unindent!

    if File.exists?('Gemfile')
      msg << Genomer::Plugin.plugins.inject(String.new) do |str,p|
        str << '  '
        str << p.name.gsub("genomer-plugin-","").ljust(12)
        str << p.summary
        str << "\n"
      end
    end
    msg.strip
  end

  def man
    if not arguments.empty?
      location = if arguments.first == 'init'
                   File.expand_path File.dirname(__FILE__) + '/../../man/genomer-init.1.ronn'
                 else
                   man_file(arguments.clone)
                 end

      unless File.exists?(location)
        raise Genomer::Error, "No manual entry for command '#{arguments.join(' ')}'"
      end

      Kernel.exec "man #{groffed_man_file(location).path}"
    else
      message :output, :man
    end
  end

  def man_file(arguments)
    plugin = arguments.first
    page = arguments.unshift("genomer").join('-') << ".ronn"
    File.join(Genomer::Plugin.fetch(plugin).full_gem_path, 'man', page)
  end

  def groffed_man_file(original_man_file)
    converted_man = Tempfile.new("genome-manpage-")
    File.open(converted_man.path,'w') do |out|
      out.puts Md2Man::ENGINE.render(File.read(original_man_file))
    end
    converted_man
  end

  def init
    project_name = arguments.first
    if File.exists?(project_name)
      raise Genomer::Error, "Directory '#{project_name}' already exists."
    end

    require 'genomer/files'

    Dir.mkdir project_name
    Dir.mkdir File.join(project_name,'assembly')

    File.open(File.join(project_name,'Gemfile'),'w') do |file|
      file.print Genomer::Files.gemfile
    end

    ['scaffold.yml','sequence.fna','annotations.gff'].each do |name|
      File.open(File.join(project_name,'assembly',name),'w') do |file|
        file.print Genomer::Files.send(name.gsub('.','_').to_sym)
      end
    end

    "Genomer project '#{project_name}' created.\n"
  end

  def run_plugin
    Genomer::Plugin[command].new(arguments,flags).run
  end

  def genomer_project?
    File.exists?('Gemfile')
  end

end
