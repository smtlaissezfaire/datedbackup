require 'rake'
require 'spec/rake/spectask'
require 'spec/rake/verify_rcov'
require 'rake/gempackagetask'

spec = Gem::Specification.new do |s|
  s.name      = "dated_backup"
  s.version   = "0.1.1"
  s.author    = "Scott Taylor"
  s.email     = "scott@railsnewbie.com"
  s.homepage  = "http://rubyforge.org/projects/datedbackup"
  s.platform  = Gem::Platform::RUBY
  s.summary   = "Incremental Dated Backups Using Rsync"
              
  s.files     = FileList["{bin,lib,example_scripts,bin}/**/*"].to_a + %w(README COPYRIGHT)
  
  s.bindir   = 'bin'
  s.executables = ["dbackup"]                
      
  s.has_rdoc          = true
  s.extra_rdoc_files  = %w(README COPYRIGHT)
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_tar = true
end

desc "Generate Rdoc"
task :rdoc => [:clobber_rdoc] do
  %x(rdoc -o doc/rdoc --exclude "Rakefile.rb" --exclude "spec/")
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
task :build_release => [:pre_commit, :repackage]

desc "Run all examples with RCov"
Spec::Rake::SpecTask.new('rcov') do |t|
  t.spec_files = FileList['spec/**/*.rb']
  t.rcov = true
  t.rcov_opts = ['--exclude', 'spec']
  t.rcov_dir = "doc/rcov"
end

RCov::VerifyTask.new(:verify_rcov => :spec) do |t|
  t.threshold = 100.0
  t.index_html = 'doc/rcov/index.html'
end

task :pre_commit => [:clobber_documentation, :generate_documentation, :verify_rcov]