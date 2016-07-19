require 'erb'
require 'fileutils'
require 'pathname'
require 'securerandom'

module GrokCLI::Docker::WordPress
  class Init
    def execute(hostname, machine_name)
      FileUtils.cp(template_path('docker-compose.yml'), '.')
      puts "Created docker-compose.yml"

      File.open('.grok-cli.yml', 'w') do |file|
        file.write(render_grok_cli(hostname, machine_name))
        puts "Created .grok-cli.yml"
      end

      File.open('.env', 'w') do |file|
        file.write(render_env)
        puts "Created .env"
      end

      File.open('wp-config.php', 'w') do |file|
        file.write(render_wp_config)
        puts "Created wp-config.php"
      end
    end

    private

    def template_path(path)
      Pathname.new(File.dirname(__FILE__)).join('./../../../templates/wordpress').join(path)
    end

    def render_grok_cli(hostname, machine_name)
      @hostname = hostname
      @machine_name = machine_name

      template = File.read(template_path('.grok-cli.yml.erb'))

      ERB.new(template).result(binding)
    end

    def render_env
      @password = SecureRandom.hex

      template = File.read(template_path('.env.erb'))

      ERB.new(template).result(binding)
    end

    def render_wp_config
      @password = SecureRandom.hex

      template = File.read(template_path('wp-config.php.erb'))

      ERB.new(template).result(binding)
    end
  end

end

module GrokCLI
  command 'docker:wordpress' do |c|

    c.desc 'Copy configuration files to a WordPress project'

    c.arg :docker_machine_name
    c.arg :hostname

    c.command 'init' do |c|
      c.action do |global_options, options, arguments|
        GrokCLI::Docker::WordPress::Init.new.execute(arguments[0], arguments[1])
      end
    end
  end
end
