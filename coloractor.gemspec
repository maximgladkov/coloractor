Gem::Specification.new do |s|
  s.name        = 'coloractor'
  s.version     = '0.0.1'
  s.date        = '2015-09-29'
  s.summary     = "Dominant colors extractor from an image file"
  s.description = "A simple ruby wrapper around colorific Python script."
  s.authors     = ["Maxim Gladkov"]
  s.email       = 'contact@maximgladkov.com'
  s.files       = ["lib/colorator.rb"]
  s.homepage    =  'http://rubygems.org/gems/colorator'
  s.license     = 'MIT'

  s.add_development_dependency 'rspec'
end
