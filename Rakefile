require 'rubygems'
require 'rake'
require 'rake/testtask'


begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "verify_me"
    gem.summary = %Q{Ruby interface to 'Verify' twitter accounts.}
    gem.description = %Q{An object oriented Ruby interface to "Verify" Twitter accounts by adding the "Verified" logo to a user's background image..}
    gem.email = "marcus@deglos.com"
    gem.authors = ["Marcus Deglos"]
    gem.add_dependency "rmagick"
    gem.files = Dir.glob('lib/**/*.rb')
    gem.files += Dir.glob('lib/**/img/*.png')
    gem.files += Dir.glob('lib/**/ttf/*.ttf')
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

task :default => :build

# Rake::TestTask.new do |t|
#   t.libs << 'test'
# end


Jeweler::GemcutterTasks.new
