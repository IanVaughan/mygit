require 'httparty'
require 'pp'

class GitHub
  include HTTParty
  base_uri 'https://api.github.com'

  def initialize(u, p)
    @auth = {:username => u, :password => p}
  end

  def repos repo
    self.class.get("/orgs/#{repo}/repos", {:basic_auth => @auth})
  end
end

class Access
  def initialize
    filename = '~/.mygit'
    file = File.expand_path filename
    conf = YAML.load_file file
    @repo = GitHub.new(conf['user'], conf['pass']).repos(conf['repo'])
  end

  def list
    @repo.each do |r|
      spaces = ' ' * (30 - r['name'].size)
      puts "#{r['name']} #{spaces} #{r['ssh_url']}"
    end
  end

  def find name
    found = nil
    @repo.each do |r|
      found = r if r['name'] == name
    end
    found
  end
end
