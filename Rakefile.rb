require 'rubygems'
Gem::manage_gems
require 'rake/gempackagetask'

spec = Gem::Specification.new do |s|
    s.name      = "dated_backup"
    s.version   = "0.1.1"
    s.author    = "Scott Taylor"
    s.email     = "scott@railsnewbie.com"
    s.homepage  = "http://rubyforge.org/projects/datedbackup"
    s.platform  = Gem::Platform::RUBY
    s.summary   = "Incremental Dated Backups Using Rsync"
                
    s.files     = FileList["{lib,example_scripts,bin}/**/*"].to_a
    
    s.bindir   = 'bin'
    s.executables = ["dbackup"]                
        
    s.has_rdoc          = true
    s.extra_rdoc_files  = %w(README DONE COPYRIGHT)
end

Rake::GemPackageTask.new(spec) do |pkg|
    pkg.need_tar = true
end
