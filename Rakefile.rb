require 'rake'
require "rake/rdoctask"
require 'spec/rake/spectask'
require 'spec/rake/verify_rcov'
require 'rake/gempackagetask'

rdoc_files = FileList["{bin,lib,example_configs}/**/*"].to_a
extra_rdoc_files = %w(README COPYRIGHT RELEASES CHANGELOG)

spec = Gem::Specification.new do |s|
  
  s.name      = "dated_backup"
  s.version   = "0.2.1"
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
  rd.rdoc_dir = "doc/rdoc/"
end

desc "Generate RSpec Report"
task :rspec_report do
  files = FileList["spec/**/*.rb"].to_s
  %x(spec #{files} --format html:doc/rspec_report.html)
end

desc "Remove RSpec Report"
task :clobber_rspec_report do
  %x(rm -rf doc/rspec_report.html)
end

desc "Remove Rdoc"
task :clobber_rdoc do
  %x(rm -rf doc/rdoc)
end

desc "Remove Rcov"
task :clobber_rcov do
  %x(rm -rf doc/rcov)
end

desc "Generate all documentation"
task :generate_documentation => [:rdoc, :rcov, :rspec_report]

desc "Remove all documentation"
task :clobber_documentation => [:clobber_rdoc, :clobber_rcov, :clobber_rspec_report]

desc "Build Release"
task :build_release => [:pre_commit, :repackage] do
  %x(mv pkg gem)
end

desc "Run all examples with RCov"
Spec::Rake::SpecTask.new('rcov') do |t|
  t.spec_files = FileList['spec/**/*.rb']
  t.rcov = true
  t.rcov_opts = ['--exclude', 'spec']
  t.rcov_dir = "doc/rcov"
end

RCov::VerifyTask.new(:verify_rcov => :rcov) do |t|
  t.threshold = 100.0
  t.index_html = 'doc/rcov/index.html'
end

task :pre_commit => [:clobber_documentation, :generate_documentation, :verify_rcov]