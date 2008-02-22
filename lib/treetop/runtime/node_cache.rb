module Treetop
  module Runtime
    class NodeCache

      def initialize
        @node_index = Hash.new {|h, k| h[k] = Hash.new }
        @node_storages = []
      end

      def store(rule_name, result)
        node_index[rule_name][result.interval.first] = result
        node_storages.push(NodeStorage.new(rule_name, result, node_index))
      end

      def get(rule_name, start_index)
        node_index[rule_name][start_index]
      end

      def has_result?(rule_name, start_index)
        node_index[rule_name].has_key?(start_index)
      end

      def expire(range, length_change)
#        puts "before vvvvvvvvvvvvvvvvvvvvvvv"
#        puts node_storages.inspect
#        pp   node_index
#        puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
        
        self.node_storages = node_storages.select do |node_storage|
          #debugger if node_storage.interval == (0...1) || node_storage.interval == (0...2)
          node_storage.reflect_buffer_change(range, length_change)
        end
        
#        puts "after vvvvvvvvvvvvvvvvvvvvvvvv"
#        puts node_storages.inspect
#        pp   node_index
#        puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
      end


      def inspect

      end

      protected
      attr_reader :node_index
      attr_accessor :node_storages
    end
  end
end
