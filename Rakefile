require 'rubygems'
gem 'hoe', '>= 2.1.0'
require 'hoe'
require 'fileutils'
require './lib/dm-fql-adapter'

Hoe.plugin :newgem
# Hoe.plugin :website
# Hoe.plugin :cucumberfeatures

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
$hoe = Hoe.spec 'dm-fql-adapter' do
  self.developer 'Greg Borenstein', 'greg.borenstein@gmail.com'
  self.version = "0.0.1"
  self.post_install_message = 'PostInstall.txt' # TODO remove if post-install message not required
  self.summary = "FQL Adapter for DataMapper"
  # self.extra_deps         = [['activesupport','>= 2.0.2']]

end

require 'newgem/tasks'
Dir['tasks/**/*.rake'].each { |t| load t }

# TODO - want other tests/tasks run by default? Add them to the list
# remove_task :default
# task :default => [:spec, :features]