module Treetop
  module Runtime
    class ParseResult
      attr_reader :dependent_results, :storages, :dependencies, :dependents
      attr_accessor :interval, :parent, :registered
      alias :registered? :registered
      
      def initialize(interval)
        @interval = interval
        @storages = []
        @dependencies = []
        @dependents = []
      end

      def expire
        dependents.each {|dependent| dependent.expire }
      end
    end
  end
end
