dir = File.dirname(__FILE__)
require 'rubygems'
require 'spec/expectations'
require 'spec/matchers'
require 'facet/string/camelize'
require File.join(dir, 'unit', 'util')
require File.join(dir, 'unit', 'assertion_failed_error')
require File.join(dir, 'unit', 'assertions')
require File.join(dir, 'unit', 'collector')
require File.join(dir, 'unit', 'error')
require File.join(dir, 'unit', 'failure')
require File.join(dir, 'unit', 'test_case')
require File.join(dir, 'unit', 'test_result')
require File.join(dir, 'unit', 'test_suite')
require File.join(dir, 'unit', 'ui')
require File.join(dir, 'unit', 'auto_runner')
require File.join(dir, 'unit', 'sugar')

module F
  module Unit
    # If set to false F::Unit will not automatically run at exit.
    def self.run=(flag)
      @run = flag
    end

    # Automatically run tests at exit?
    def self.run?
      @run ||= false
    end
  end
end

at_exit do
  unless $! || F::Unit.run?
    exit F::Unit::AutoRunner.run
  end
end
