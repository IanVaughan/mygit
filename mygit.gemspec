Gem::Specification.new do |s|
  s.name        = "mygit"
  s.version     = '0.0.11'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ian Vaughan"]
  s.email       = ["mygit@ianvaughan.co.uk"]
  s.homepage    = "http://github.com/ianvaughan/mygit"
  s.summary     = "Some CLI commands to talk to GitHub"
  s.description = "Allows you to do cool things from the CLI with GitHub"
  s.license     = 'MIT'

  s.add_dependency    'httparty'
  s.add_dependency    'highline'

  # s.files        = %w{README.md bin/mygit}
  s.files             = %w( README.md LICENSE )
  s.files            += Dir.glob("lib/*")
  s.files            += Dir.glob("bin/*")

  s.executables  = ['mygit']
end
