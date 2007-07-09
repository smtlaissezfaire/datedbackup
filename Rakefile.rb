require 'rubygems'
Gem::manage_gems
require 'rake/gempackagetask'

spec = Gem::Specification.new do |s|
    s.name       = "dated_backup"
    s.version    = "0.1.0"
    s.author     = "Scott Taylor"
    s.email      = "scott@railsnewbie.com"
    s.homepage   = "http://rubyforge.org/projects/datedbackup"
    s.platform   = Gem::Platform::RUBY
    s.summary    = "Incremental Backups Using Rsync"
    
    s.files      = FileList["lib/**/*"].to_a
        
    s.has_rdoc          = false
    #s.extra_rdoc_files  = %w(README TODO DONE)
end

Rake::GemPackageTask.new(spec) do |pkg|
    pkg.need_tar = true
end
