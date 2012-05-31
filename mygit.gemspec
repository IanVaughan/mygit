Gem::Specification.new do |s|
  s.name        = "mygit"
  s.version     = '0.0.2'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ian Vaughan"]
  s.email       = ["mygit@ianvaughan.co.uk"]
  s.homepage    = "http://github.com/ianvaughan/mygit"
  s.summary     = "Some CLI commands to talk to GitHub"
  s.description = "Allows you to do cool things from the CLI with GitHub"

  s.license           = 'MIT'

  s.add_dependency    'httparty'

  s.files        = %w{README.md bin/mygit}
  s.executables  = ['mygit']
end
