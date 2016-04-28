module GrokCLI::Docker
  class UpdateEtcHosts
    def initialize(config = Configuration.new)
      @config = config
    end

    def execute
      system <<~CMD

        IP=`docker-machine ip #{@config.machine_name}`

        IP_MAP="$IP #{@config.hostname}"

        if grep -Fxq "$IP_MAP" /etc/hosts; then
          :
        else

          if sudo -n true 2>/dev/null; then
            :
          else
            echo "You may be prompted for your password; this is to permit updating your /etc/hosts for #{@config.hostname}"
          fi

          sudo sed -i '' '/#{@config.hostname.gsub('.', '\.')}$/d' /etc/hosts

          echo $IP_MAP | sudo tee -a /etc/hosts
        fi

      CMD
    end
  end
end

module GrokCLI

  definition = Proc.new do |c|
    c.desc "Updates /etc/hosts with the configured hostname and current IP address"

    c.command 'update-hosts-file' do |c|
      c.action do
        GrokCLI::Docker::UpdateEtcHosts.new.execute
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
