require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

#desc 'Default: run unit tests.' TODO
#task :default => :test

#desc 'Test the x_accel_redirect plugin.' TODO
#Rake::TestTask.new(:test) do |t|
#  t.libs << 'lib'
#  t.pattern = 'test/**/*_test.rb'
#  t.verbose = true
#end

desc 'Generate documentation for the x_accel_redirect plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'XAccelRedirect'
  rdoc.options << '--line-numbers' << '--inline-source' << '--accessor=cattr_accessor'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

