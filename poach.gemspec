Gem::Specification.new do |s|
  s.name = "poach"
  s.version = "0.1.0"
  s.licenses = ['MIT']
  s.summary = 'Packages nashorn projects into executable jar files'
  s.authors = "Jared Breeden"
  s.files = [
    'bin/poach',
    'lib/poach.rb',
    'resources/nashorn-main.jar'
  ]
  s.executables << 'poach'
  s.add_runtime_dependency 'thor'
end