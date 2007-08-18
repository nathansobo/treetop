class Object
  def context(description, options = {}, &block)
    superclass = options[:extend] || Screw::Unit::TestCase
    test_case_class = Class.new(superclass, &block)
    test_case_class.test_case_description = description
    Object.send(:const_set, unique_test_case_name(description.sanitize.camelize), test_case_class)
  end
  
  def unique_test_case_name(name, n=1)
    candidate_name = (n > 1 ? "#{name}#{n}" : name).to_sym
    if Object.const_defined?(candidate_name)
      unique_test_case_name(name, n + 1)
    else
      candidate_name
    end
  end
  
  alias :describe :context
end

class String
  def sanitize
    self.gsub(/[^\w]+/, "_")
  end
end