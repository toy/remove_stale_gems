require 'rubygems/uninstaller'

class Gem::Commands::RemoveStaleCommand < Gem::Command
  def initialize
    super 'remove_stale', 'Remove gems for which last use time is too old'
  end

  def abandoned?(spec, border_time)
    atime = nil
    Dir["#{spec.full_gem_path}/**/*.*"].each do |file|
      next if File.directory?(file)
      stat = File.stat(file)
      atime = stat.atime if !atime || atime < stat.atime
    end
    atime && atime < border_time
  end

  def execute
    border_time = Time.now - 40 * (24 * 60 * 60)

    abandoned_gems = []
    Gem.source_index.each do |name, spec|
      if abandoned?(spec, border_time)
        abandoned_gems << spec
      end
    end

    to_uninstall = abandoned_gems.select do |spec|
      spec.dependent_gems.all? do |dependent, depency, satlist|
        abandoned_gems.include?(dependent) || (satlist - abandoned_gems).length > 0
      end
    end

    to_uninstall.each do |spec|
      say "Attempting to uninstall #{spec.full_name}"

      uninstall_options = {
        :executables => (Gem.source_index.find_name(spec.name) - to_uninstall).length == 0,
        :version => "= #{spec.version}",
        :ignore => true
      }
      uninstaller = Gem::Uninstaller.new spec.name, uninstall_options

      begin
        uninstaller.uninstall
      rescue Gem::DependencyRemovalException, Gem::InstallError,
              Gem::GemNotInHomeException => e
        say "Unable to uninstall #{spec.full_name}:"
        say "\t#{e.class}: #{e.message}"
      end
    end
  end
end
