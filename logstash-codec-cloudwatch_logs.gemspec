Gem::Specification.new do |s|
  s.name          = 'logstash-codec-cloudwatch_logs'
  s.version       = '0.0.2'
  s.licenses      = ['Apache License (2.0)']
  s.summary       = "Parse CloudWatch Logs subscription data"
  s.description   = "This gem is a Logstash plugin required to be installed on top of the Logstash core pipeline using $LS_HOME/bin/logstash-plugin install gemname. This gem is not a stand-alone program"
  s.authors       = ["Anthony M."]
  s.email         = 'tony@threadwaste.com'
  s.homepage      = "https://github.com/threadwaste/logstash-codec-cloudwatch_logs"
  s.require_paths = ["lib"]

  # Files
  s.files = Dir['lib/**/*','spec/**/*','vendor/**/*','*.gemspec','*.md','CONTRIBUTORS','Gemfile','LICENSE','NOTICE.TXT']

  # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "codec" }

  # Gem dependencies
  s.add_runtime_dependency 'logstash-core-plugin-api', '>= 1.60', '<= 2.99'
  s.add_runtime_dependency 'cabin', '~> 0.6'

  s.add_development_dependency 'logstash-devutils', '>= 0.0.16'
  s.add_development_dependency 'logstash-codec-json'
  s.add_development_dependency 'tins', '1.6'
 
end
