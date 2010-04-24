begin
  require 'jeweler'

  name = 'remove_stale_gems'
  summary = 'Remove unused gems'
  description = 'Remove gems for which last use time is too old'

  jewel = Jeweler::Tasks.new do |j|
    j.name = name
    j.summary = summary
    j.description = description
    j.authors = ["Boba Fat"]
  end

  Jeweler::GemcutterTasks.new

  require 'pathname'
  desc "Replace system gem with symlink to this folder"
  task 'ghost' do
    gem_path = Pathname(Gem.searcher.find(name).full_gem_path)
    current_path = Pathname('.').expand_path
    system('rm', '-r', gem_path)
    system('ln', '-s', current_path, gem_path)
  end

rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end
