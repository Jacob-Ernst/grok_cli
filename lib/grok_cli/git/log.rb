require 'git'
require 'erb'
require 'uri'

module GrokCLI::Git
  class Log

    def execute(since_hours_ago:, domains:, author:)
      pwd = Dir.pwd
      git = Git.open(pwd)

      map = {}

      git.log.author(author).since("#{since_hours_ago} hours ago").reverse_each do |commit|
        uris = URI.extract(commit.message)

        uris.select! do |uri|
          uri.match(domains) ? true : false
        end

        if uris.empty?
          map['No Ticket'] ||= []
        else
          uris.each do |uri|
            map[uri] ||= []
          end
        end

        if uris.empty?
          map['No Ticket'] << commit
        else
          uris.each do |uri|
            map[uri] << commit
          end
        end
      end

      entries = map.map do |ticket, commits|
        Entry.new(ticket: ticket, commits: commits).to_s
      end

      puts entries.join("\n#{'-'*72}\n\n")
    end

    class Entry
      include ERB::Util

      def initialize(ticket:, commits:)
        @ticket = ticket
        @commits = commits
      end

      def to_s
        ERB.new(<<~DOC
        #{ticket}

        #{commit_log}
        DOC
        ).result(binding)
      end

      private

      attr_reader :ticket, :commits

      def commit_log
        commits.map do |commit|
          sha = commit.sha[0..8]
          message = commit.message.split("\n").first

          "#{sha} (#{message})"
        end.join("\n")
      end
    end
  end
end

module GrokCLI
  command 'git' do |c|

    c.desc "Generate a git log organized by ticket"
    c.long_desc <<-DESC
      Generates a list of hashs and commit summaries organized by ticket
    DESC

    c.command 'log' do |c|
      c.flag [:s, :since],
        type: Integer,
        default_value: 24,
        desc: 'The number of hours since now to search the log'

      c.flag [:d, :domains],
        type: Regexp,
        default_value: /trello\.com|atlassian\.net|asana\.com/,
        desc: 'A regular expression to search against domain names'

      c.flag [:a, :author],
        type: String,
        default_value: ::Git::Lib.new.global_config_get('user.name'),
        desc: 'The git user\'s name to view history'

      c.action do |global_options,options,arguments|
        GrokCLI::Git::Log.new.execute(since_hours_ago: options[:since], domains: options[:domains], author: options[:author])
      end
    end
  end
end
