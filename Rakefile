require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "passenger_dyno"
    gem.summary = "Make tracking passenger server usage easier with MongoDb"
    gem.description = <<-EOF
      Store passenger memory usage and other useful statitics in MongoDb. Use
      passenger_dyno_clinet to see those stats rendered with javascript!
    EOF
    gem.email = "bob.burbach@gmail.com"
    gem.homepage = "http://github.com/peregrinator/passenger_dyno"
    gem.authors = ["Bob Burbach"]
    gem.add_development_dependency "thoughtbot-shoulda", ">= 0"
    gem.requirements << 'MongoDb  >= 1.4.0'
    gem.add_dependency('mongo',        '>= 0.19.3')
    gem.add_dependency('bson_ext',    '>= 0.19.3')
    gem.add_dependency('mongo_mapper', '>= 0.7.2')
    gem.add_dependency('ghazel-daemons', '>= 1.0.12')
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "passenger_dyno #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
