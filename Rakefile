require 'rake'
require 'jeweler'
require 'rake/gem_ghost_task'

name = 'remove_stale_gems'

Jeweler::Tasks.new do |gem|
  gem.name = name
  gem.summary = %Q{Remove unused gems}
  gem.description = %Q{Remove gems for which last use time is too old}
  gem.homepage = "http://github.com/toy/#{name}"
  gem.license = 'MIT'
  gem.authors = ['Ivan Kuchin']
  gem.add_development_dependency 'jeweler', '~> 1.5.1'
  gem.add_development_dependency 'rake-gem-ghost'
end
Jeweler::RubygemsDotOrgTasks.new
Rake::GemGhostTask.new
