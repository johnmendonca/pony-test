require "rubygems"
require "rake/gempackagetask"
require "rake/rdoctask"

task :default => :spec

require "rspec"
RSpec::Rake::SpecTask.new do |t|
  t.rspec_opts = %w(--colour)
end

# This builds the actual gem. For details of what all these options
# mean, and other ones you can add, check the documentation here:
#
#   http://rubygems.org/read/chapter/20
#
spec = Gem::Specification.new do |s|
  # Change these as appropriate
  s.name              = "pony-test"
  s.version           = "0.1.1"
  s.summary           = "Collection of helper methods and Cucumber steps for testing email through Pony"
  s.author            = "John Mendonca"
  s.email             = "joaosihno@gmail.com"
  s.homepage          = "http://github.com/johnmendonca/pony-test"

  s.has_rdoc          = true
  s.extra_rdoc_files  = %w(README.rdoc)
  s.rdoc_options      = %w(--main README.rdoc)

  # Add any extra files to include in the gem
  s.files             = %w(Rakefile README.rdoc) + Dir.glob("{spec,lib/**/*}")
  s.require_paths     = ["lib"]

  # If you want to depend on other gems, add them here, along with any
  # relevant versions
  # s.add_dependency("")

  # If your tests use any gems, include them here
  s.add_development_dependency("pony", "~> 0.6.0")
  s.add_development_dependency("rspec")
  s.add_development_dependency("cucumber")
  s.add_development_dependency("webrat")
  s.add_development_dependency("rack-test")

  # If you want to publish automatically to rubyforge, you'll may need
  # to tweak this, and the publishing task below too.
  s.rubyforge_project = "pony-test"
end

# This task actually builds the gem. We also regenerate a static
# .gemspec file, which is useful if something (i.e. GitHub) will
# be automatically building a gem for this project. If you're not
# using GitHub, edit as appropriate.
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec

  # Generate the gemspec file for github.
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, "w") {|f| f << spec.to_ruby }
end

# Generate documentation
Rake::RDocTask.new do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc", "lib/**/*.rb")
  rd.rdoc_dir = "rdoc"
end

desc 'Clear out RDoc and generated packages'
task :clean => [:clobber_rdoc, :clobber_package] do
  rm "#{spec.name}.gemspec"
end

# If you want to publish to RubyForge automatically, here's a simple
# task to help do that. If you don't, just get rid of this.
# Be sure to set up your Rubyforge account details with the Rubyforge
# gem; you'll need to run `rubyforge setup` and `rubyforge config` at
# the very least.
begin
  require "rake/contrib/sshpublisher"
  namespace :rubyforge do

    desc "Release gem and RDoc documentation to RubyForge"
    task :release => ["rubyforge:release:gem", "rubyforge:release:docs"]

    namespace :release do
      desc "Release a new version of this gem"
      task :gem => [:package] do
        require 'rubyforge'
        rubyforge = RubyForge.new
        rubyforge.configure
        rubyforge.login
        rubyforge.userconfig['release_notes'] = spec.summary
        path_to_gem = File.join(File.dirname(__FILE__), "pkg", "#{spec.name}-#{spec.version}.gem")
        puts "Publishing #{spec.name}-#{spec.version.to_s} to Rubyforge..."
        rubyforge.add_release(spec.rubyforge_project, spec.name, spec.version.to_s, path_to_gem)
      end

      desc "Publish RDoc to RubyForge."
      task :docs => [:rdoc] do
        config = YAML.load(
            File.read(File.expand_path('~/.rubyforge/user-config.yml'))
        )

        host = "#{config['username']}@rubyforge.org"
        remote_dir = "/var/www/gforge-projects/pony-test/" # Should be the same as the rubyforge project name
        local_dir = 'rdoc'

        Rake::SshDirPublisher.new(host, remote_dir, local_dir).upload
      end
    end
  end
rescue LoadError
  puts "Rake SshDirPublisher is unavailable or your rubyforge environment is not configured."
end
