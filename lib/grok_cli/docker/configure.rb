module GrokCLI::Docker
  class Configure
    def execute(machine_name, hostname)
      body = <<~BODY
        machine_name: #{machine_name}
        hostname: #{hostname}
        BODY

      File.open('.grok-cli.yml', 'w') do |f|
        f.write(body)
      end

      puts "Created the file \".grok-cli.yml\"\n\n#{body}"
    end

  end
end

module GrokCLI
  include GLI::App

  definition = Proc.new do |c|
    c.desc "Generate a .grok-cli.yml configuration file"
    c.long_desc <<-DESC
      Generate a .grok-cli.yml configuration file

      The other docker: commands will use this configuration file
      when booting the docker machine and configuring /etc/hosts
    DESC

    c.arg :docker_machine_name
    c.arg :hostname

    c.command 'configure' do |c|
      c.action do |global_options, options, arguments|
        GrokCLI::Docker::Configure.new.execute(arguments[0], arguments[1])
      end
    end
  end

  command 'docker' do |c|
    definition.call(c)
  end

  command 'docker:node' do |c|
    definition.call(c)
  end

  command 'docker:rails' do |c|
    definition.call(c)
  end
end
