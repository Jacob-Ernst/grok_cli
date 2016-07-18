module GrokCLI::Docker::WordPress
  class ImportDatabase
    def initialize(config = GrokCLI::Docker::Configuration.new)
      @config = config
    end

    def execute(sql_dump)
      system <<~CMD

        docker-machine create #{@config.machine_name} --driver virtualbox

        eval "$(docker-machine env #{@config.machine_name})"

        docker-compose run --rm mysql mysql -h mysql -u#{username} -p#{password} #{database} < #{sql_dump}
      CMD
    end

    private

    def username
      config.fetch('MYSQL_USER')
    end

    def password
      config.fetch('MYSQL_PASSWORD')
    end

    def database
      config.fetch('MYSQL_DATABASE')
    end

    def config
      Hash[*File.read('.env').split(/[=|\n]+/)]
    end
  end
end

module GrokCLI
  command 'docker:wordpress' do |c|

    c.desc 'Import a database into the MySQL instance'

    c.arg :sql_dump

    c.command 'import_database' do |c|
      c.action do |global_options, options, arguments|
        GrokCLI::Docker::WordPress::ImportDatabase.new.execute(arguments[0])
      end
    end
  end
end
