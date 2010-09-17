# Setup the $LOAD_PATH for use with rspec
require 'spec'
require 'spec/rake/spectask'

Spec::Rake::SpecTask.new do |task|
	task.libs << 'lib'
end


#
# Gem Packaging
require 'rake/gempackagetask'

# Config
gem_name = 'wormhole'


gem_spec = eval(File.read(gem_name+'.gemspec'))

Rake::GemPackageTask.new(gem_spec) do |p|
	p.gem_spec = gem_spec
	p.need_tar = true
	p.need_zip = true
end

#
# Gem Management
desc "Install the created gem."
task :install => :gem do
	system("gem install pkg/#{gem_spec.name}-#{gem_spec.version}.gem")
end

desc "Uninstall the gem."
task :uninstall do
	system("gem uninstall #{gem_spec.name}")
end

desc "Delete generated files"
task :clean => :clobber_package do
	# all handled by dependencies for now. 
end

