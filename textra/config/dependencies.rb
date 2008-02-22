Rucola::Dependencies.run do
  $LOAD_PATH.push(File.expand_path("#{File.dirname(__FILE__)}/../../lib"))
  require 'treetop'
  require 'ruby-debug'
end