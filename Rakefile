
begin
  require "#{dir = File.dirname(__FILE__)}/task/gemgem"
rescue LoadError
  sh 'git submodule update --init'
  exec Gem.ruby, '-S', $PROGRAM_NAME, *ARGV
end

Gemgem.init(dir) do |s|
  s.name    = 'xmpp4r-robot'
  s.version = '0.2.0'
  s.add_runtime_dependency('xmpp4r', '~> 0.5')
end
