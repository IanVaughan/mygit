require 'httparty'
require 'highline/import'

class GitHub
  include HTTParty
  base_uri 'https://api.github.com'

  def initialize(u, p)
    @auth = {:username => u, :password => p}
  end

  def repos repo
    self.class.get("/orgs/#{repo}/repos?per_page=100", {:basic_auth => @auth})
  end
end

class FileStorage
  CONFIG_DIR = "#{Dir.home}/.mygit"
  CONFIG_FILE = "#{CONFIG_DIR}/config.yml"
  REPOS_FILE = "#{CONFIG_DIR}/repos.yml"

  attr_reader :repo

  def initialize
    @repo ||= YAML.load_file REPOS_FILE if File.exist?(REPOS_FILE)
  end

  class << self
    def update filename = CONFIG_FILE
      # Get username from prompt if file missing
      file = File.expand_path filename
      conf = YAML.load_file file
      gh = GitHub.new(conf['user'], get_input("Enter password: ", '*'))

      repo = gh.repos(conf['repo'])
      keep = remove_keys repo
      save keep
    end

    KEEP_KEYS = ['name', 'ssh_url', 'html_url']
    def remove_keys array
      keep = []
      array.each do |a|
        keep << a.keep_if {|k| KEEP_KEYS.include? k }
      end
      keep
    end

    def get_input prompt, echo = true
      ask(prompt) {|q| q.echo = echo}
    end

    def save data
      File.open(REPOS_FILE, "w+") {|f| f.puts(data.to_yaml) }
      # File.open(fnm, ‘w’) { |out| YAML.dump(h, out) }
    end
  end
end

class Access
  COL_WIDTH = 30

  class << self
    def list
      repo.each do |r|
        spaces = ' ' * (COL_WIDTH - r['name'].size) unless r['name'].size > COL_WIDTH
        puts "#{r['name']} #{spaces} #{r['ssh_url']}"
      end
    end

    def find name
      found = nil
      repo.each do |r|
        found = r if r['name'] == name
      end
      found
    end

    def repo
      @repo ||= FileStorage.new.repo
    end
  end
end

class Commands
  class << self
    def current_branch
      `git rev-parse --abbrev-ref HEAD`
    end

    def branch_url
      "tree/#{current_branch}"
    end

    # TODO: Use OptionsParser
    def execute args
      cmd = args.shift
      case cmd
      when 'update'
        FileStorage::update
      when 'list'       # dumps a list of all repos found
        Access::list
      when 'find'       # find a repo by name
        pp Access::find args.shift
      when 'clone'      # clone a repo by name
        p = Access::find args.shift
        cmd = "git clone #{p['ssh_url']}"
        system cmd
      when 'open'       # Opens either the current pwd, or a supplied project, GitHub project page in a browser
        opt = args.shift
        opt = File.basename(Dir.getwd) if opt.nil?
        p = Access::find opt
        system "open #{p['html_url']}/#{branch_url}"
      else
        puts 'Unknown or no command given! Options are :-'
        File.open(__FILE__).each_line do |line|
          puts "  " + line.sub('when','').sub('#', '->').gsub('\'','') if line.include? 'when'
          break if line.include? 'else'
        end
      end
    end
  end
end
