require File.dirname(__FILE__) + "/lib/dated_backup/core/version"

require 'rake'
require "rake/rdoctask"
require 'rake/gempackagetask'
$:.unshift File.dirname(__FILE__) + '/vendor/plugins/rspec/rspec/lib/'
require 'spec/rake/spectask'
require 'spec/rake/verify_rcov'

rdoc_files = FileList["{bin,lib,example_configs}/**/*"].to_a
extra_rdoc_files = %w(README MIT-LICENSE GPL-LICENSE RELEASES CHANGELOG)

spec = Gem::Specification.new do |s| 
  s.name      = "dated_backup"
  s.version   = DatedBackup::Version.to_s
  s.author    = "Scott Taylor"
  s.email     = "scott@railsnewbie.com"
  s.homepage  = "http://rubyforge.org/projects/datedbackup"
  s.platform  = Gem::Platform::RUBY
  s.summary   = "Incremental Dated Backups Using Rsync"
              
  s.files     = rdoc_files + extra_rdoc_files
  
  s.bindir   = 'bin'
  s.executables = ["dbackup"]   
  
  s.add_dependency 'activesupport', '>= 1.4.2'             
      
  s.has_rdoc          = true
  s.extra_rdoc_files  = FileList["example_configs/**/*"].to_a + extra_rdoc_files
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_tar = true
end

Rake::RDocTask.new do |rd|
  rd.main = "README"
  rd.rdoc_files.include(rdoc_files, extra_rdoc_files)
  rd.rdoc_dir = "doc/"
end

desc "Run all examples with RCov"
Spec::Rake::SpecTask.new(:rcov) do |t|
  t.spec_files = FileList['spec/**/*.rb']
  t.rcov = true
  t.rcov_opts = ['--exclude', 'spec']
  t.rcov_dir = "doc/rcov"
end

desc "Run all specs"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec/**/*.rb']
  t.rcov = false
  t.spec_opts = ["--color"]
end

RCov::VerifyTask.new(:verify_rcov => :rcov) do |t|
  t.threshold = 100.0
  t.index_html = 'doc/rcov/index.html'
end

desc "Current Version"
task :current_version do
  puts DatedBackup::Version.to_s
end

desc "Generate RSpec Report"
task :rspec_report => [:clobber_rspec_report] do
  files = FileList["spec/**/*.rb"].to_s
  %x(spec #{files} --format html:doc/rspec_report.html)
end

task :clobber_rspec_report do
  %x(rm -rf doc/rspec_report.html)
end

desc "Generate all documentation"
task :generate_documentation => [:clobber_documentation, :rdoc, :rcov, :rspec_report]

desc "Remove all documentation"
task :clobber_documentation => [:clobber_rdoc, :clobber_rcov, :clobber_rspec_report]

desc "Build Release"
task :build_release => [:pre_commit, :generate_documentation, :repackage] do
  %x(mv pkg gem)
end

desc "Run this before commiting"
task :pre_commit => [:verify_rcov]
