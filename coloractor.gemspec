Gem::Specification.new do |s|
  s.name        = 'coloractor'
  s.version     = '0.0.2'
  s.date        = '2015-09-29'
  s.summary     = "Dominant colors extractor from an image file"
  s.description = "A simple ruby wrapper around colorific Python script."
  s.authors     = ["Maxim Gladkov"]
  s.email       = 'contact@maximgladkov.com'
  s.files       = ["lib/coloractor.rb", "lib/coloractor/palette.rb"]
  s.homepage    =  'http://rubygems.org/gems/colorator'
  s.license     = 'MIT'

	s.add_dependency 'mini_magick'
	s.add_dependency 'color'

  s.add_development_dependency 'rspec'
end
