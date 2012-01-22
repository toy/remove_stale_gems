require 'rubygems/uninstaller'

class Gem::Commands::RemoveStaleCommand < Gem::Command
  def initialize
    super 'remove_stale', 'Remove gems for which last use time is too old'

    add_option('-y', '--yes', 'Don\'t ask for confirmation') do |value, options|
      options[:yes] = true
    end

    add_option('-d', '--days DAYS', 'Consider stale after no access for this number of days (Default: 40)') do |value, options|
      options[:days] = value.to_i
    end
  end

  def gem_atime(spec)
    Dir["#{spec.full_gem_path}/**/*.*"].reject do |path|
      File.directory?(path)
    end.map do |path|
      File.stat(path).atime
    end.max
  end

  def stale_gem?(spec, border_time)
    (atime = gem_atime(spec)) && (atime < border_time)
  end

  def execute
    days = options[:days] || 40
    border_time = Time.now - days  * (24 * 60 * 60)

    stale_gems = Gem::Specification.select do |spec|
      stale_gem?(spec, border_time)
    end

    to_uninstall = stale_gems.select do |spec|
      spec.dependent_gems.all? do |dependent, depency, satlist|
        stale_gems.include?(dependent) || (satlist - stale_gems).length > 0
      end
    end

    if to_uninstall.empty?
      puts 'No stale gems found.'
    else
      puts 'Stale gems:'
      to_uninstall.group_by(&:name).sort.each do |name, specs|
        all_versions = Gem::Specification.find_all_by_name(name).map(&:version)
        versions_to_uninstall = specs.map(&:version).sort
        versions_to_leave = all_versions - versions_to_uninstall
        line = "  #{name}: #{versions_to_uninstall.join(', ')}"
        unless versions_to_leave.empty?
          line << " (leaving versions: #{versions_to_leave.join(', ')})"
        end
        puts line
      end
      if options[:yes] || ask_yes_no('Remove gems?')
        to_uninstall.each do |spec|
          say "Attempting to uninstall #{spec.full_name}"
          begin
            Gem::Uninstaller.new(spec.name, {
              :version => "= #{spec.version}",
              :executables => true,
              :ignore => true
            }).uninstall
          rescue Gem::DependencyRemovalException, Gem::InstallError, Gem::GemNotInHomeException => e
            say "Unable to uninstall #{spec.full_name}:"
            say "  #{e.class}: #{e.message}"
          end
        end
      end
    end
  end
end
