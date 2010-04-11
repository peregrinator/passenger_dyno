# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{passenger_dyno}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Bob Burbach"]
  s.date = %q{2010-04-11}
  s.description = %q{      Store passenger memory usage and other useful statitics in MongoDb. Use
      passenger_dyno_clinet to see those stats rendered with javascript!
}
  s.email = %q{bob.burbach@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.mdown"
  ]
  s.files = [
    "LICENSE",
     "README.mdown",
     "Rakefile",
     "VERSION",
     "examples/config.yml",
     "examples/database.yml",
     "lib/dyno/dyno_server.rb",
     "lib/dyno/dyno_server_check.rb",
     "lib/dyno_check.rb",
     "lib/mongo_store.rb",
     "lib/passenger/passenger_overview.rb",
     "lib/passenger/passenger_thread.rb",
     "lib/passenger_dyno.rb",
     "passenger_dyno.gemspec",
     "pkg/passenger_dyno-0.0.1.gem",
     "test/helper.rb",
     "test/test_passenger_dyno.rb",
     "utilities/dyno_daemon.rb",
     "utilities/dyno_test.rb"
  ]
  s.homepage = %q{http://github.com/peregrinator/passenger_dyno}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.requirements = ["MongoDb  >= 1.4.0"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Make tracking passenger server usage easier with MongoDb}
  s.test_files = [
    "test/helper.rb",
     "test/test_passenger_dyno.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<thoughtbot-shoulda>, [">= 0"])
      s.add_runtime_dependency(%q<mongo>, [">= 0.19.3"])
      s.add_runtime_dependency(%q<bson_ext>, [">= 0.19.3"])
      s.add_runtime_dependency(%q<mongo_mapper>, [">= 0.7.2"])
      s.add_runtime_dependency(%q<ghazel-daemons>, [">= 1.0.12"])
    else
      s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
      s.add_dependency(%q<mongo>, [">= 0.19.3"])
      s.add_dependency(%q<bson_ext>, [">= 0.19.3"])
      s.add_dependency(%q<mongo_mapper>, [">= 0.7.2"])
      s.add_dependency(%q<ghazel-daemons>, [">= 1.0.12"])
    end
  else
    s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    s.add_dependency(%q<mongo>, [">= 0.19.3"])
    s.add_dependency(%q<bson_ext>, [">= 0.19.3"])
    s.add_dependency(%q<mongo_mapper>, [">= 0.7.2"])
    s.add_dependency(%q<ghazel-daemons>, [">= 1.0.12"])
  end
end

