require 'markaby'

module Treetop
  class FailureChain
    attr_reader :failures, :terminal_failure
    
    def initialize(terminal_failure)
      @terminal_failure = terminal_failure
      @failures =  [terminal_failure]
    end
    
    def terminal_index
      terminal_failure.index
    end
    
    def add(failure)
      failures.unshift(failure)
      return self
    end
    
    def to_s
      s = "#{terminal_index}:\n"
      failures.each_with_index do |failure, failure_number|
        s << ("\t" * failure_number) << failure.parsing_expression.to_s << "\n"
      end
      s
    end
    
    def to_html
      mb = Markaby::Builder.new({}, self)
      mb.div do
        div("#{terminal_index}:")
        failures.each_with_index do |failure, index|
          div :style => "margin-left: #{index * 5}px;" do
            unless failure.parsing_expression.nil?
              text("#{failure.index}: ")
              text(failure.parsing_expression.to_s)
            end
          end
        end
      end
      mb.to_s
    end
  end
end