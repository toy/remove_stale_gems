# encoding: UTF-8

Gem::Specification.new do |s|
  s.name        = 'remove_stale_gems'
  s.version     = '1.0.2'
  s.summary     = %q{Remove unused gems}
  s.description = %q{Remove gems for which last use time is too old}
  s.homepage    = "http://github.com/toy/#{s.name}"
  s.authors     = ['Ivan Kuchin']
  s.license     = 'MIT'

  s.rubyforge_project = s.name

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = %w[lib]
end
