module Arithmetic
  include Treetop::Runtime

  def root
    @root || :expression
  end

  def _nt_expression
    start_index = index
    if expirable_result_cache.has_result?(:expression, index)
      cached = expirable_result_cache.get_result(:expression, index)
      @index = cached.resume_index if cached
      return cached
    end

    i0 = index
    failed_alternatives = []
    r1 = _nt_comparative
    if r1 && !r1.is_a?(ParseFailure)
      r0 = r1
      r0 = Propagation.new(r0)
    else
      failed_alternatives << r1
      r2 = _nt_additive
      if r2 && !r2.is_a?(ParseFailure)
        r0 = r2
        r0 = Propagation.new(r0)
      else
        failed_alternatives << r2
        self.index = i0
        failure_range = (max_terminal_failure_last_index > input_length) ? (i0..max_terminal_failure_last_index) : (i0...max_terminal_failure_last_index)
        r0 = ParseFailure.new(failure_range)
      end
    end
    r0.dependencies.concat(failed_alternatives)

    expirable_result_cache.store_result(:expression, r0)

    return r0
  end

  module Comparative0
    def operand_1
      elements[0]
    end

    def space
      elements[1]
    end

    def operator
      elements[2]
    end

    def space
      elements[3]
    end

    def operand_2
      elements[4]
    end
  end

  def _nt_comparative
    start_index = index
    if expirable_result_cache.has_result?(:comparative, index)
      cached = expirable_result_cache.get_result(:comparative, index)
      @index = cached.resume_index if cached
      return cached
    end

    i0, s0 = index, []
    start_max_terminal_failure_last_index = max_terminal_failure_last_index
    local_max_terminal_failure_last_index = max_terminal_failure_last_index
    r1 = _nt_additive
    local_max_terminal_failure_last_index = max_terminal_failure_last_index
    @max_terminal_failure_last_index = start_max_terminal_failure_last_index
    s0 << r1
    if r1 && !r1.is_a?(ParseFailure)
      start_max_terminal_failure_last_index = max_terminal_failure_last_index
      local_max_terminal_failure_last_index = max_terminal_failure_last_index
      r2 = _nt_space
      local_max_terminal_failure_last_index = max_terminal_failure_last_index
      @max_terminal_failure_last_index = start_max_terminal_failure_last_index
      s0 << r2
      if r2 && !r2.is_a?(ParseFailure)
        start_max_terminal_failure_last_index = max_terminal_failure_last_index
        local_max_terminal_failure_last_index = max_terminal_failure_last_index
        r3 = _nt_equality_op
        local_max_terminal_failure_last_index = max_terminal_failure_last_index
        @max_terminal_failure_last_index = start_max_terminal_failure_last_index
        s0 << r3
        if r3 && !r3.is_a?(ParseFailure)
          start_max_terminal_failure_last_index = max_terminal_failure_last_index
          local_max_terminal_failure_last_index = max_terminal_failure_last_index
          r4 = _nt_space
          local_max_terminal_failure_last_index = max_terminal_failure_last_index
          @max_terminal_failure_last_index = start_max_terminal_failure_last_index
          s0 << r4
          if r4 && !r4.is_a?(ParseFailure)
            start_max_terminal_failure_last_index = max_terminal_failure_last_index
            local_max_terminal_failure_last_index = max_terminal_failure_last_index
            r5 = _nt_additive
            local_max_terminal_failure_last_index = max_terminal_failure_last_index
            @max_terminal_failure_last_index = start_max_terminal_failure_last_index
            s0 << r5
          end
        end
      end
    end
    @max_terminal_failure_last_index = local_max_terminal_failure_last_index
    if !s0.last.is_a?(ParseFailure)
      r0 = (BinaryOperation).new(input, i0...index, s0)
      r0.extend(Comparative0)
    else
      self.index = i0
      failure_range = (max_terminal_failure_last_index > input_length) ? (i0..max_terminal_failure_last_index) : (i0...max_terminal_failure_last_index)
      r0 = ParseFailure.new(failure_range)
      r0.dependencies.concat(s0)
    end

    expirable_result_cache.store_result(:comparative, r0)

    return r0
  end

  module EqualityOp0
    def apply(a, b)
      a == b
    end
  end

  def _nt_equality_op
    start_index = index
    if expirable_result_cache.has_result?(:equality_op, index)
      cached = expirable_result_cache.get_result(:equality_op, index)
      @index = cached.resume_index if cached
      return cached
    end

    if input.index('==', index) == index
      r0 = (SyntaxNode).new(input, index...(index + 2))
      r0.extend(EqualityOp0)
      @index += 2
    else
      r0 = terminal_parse_failure('==', 2)
    end

    expirable_result_cache.store_result(:equality_op, r0)

    return r0
  end

  module Additive0
    def operand_1
      elements[0]
    end

    def space
      elements[1]
    end

    def operator
      elements[2]
    end

    def space
      elements[3]
    end

    def operand_2
      elements[4]
    end
  end

  def _nt_additive
    start_index = index
    if expirable_result_cache.has_result?(:additive, index)
      cached = expirable_result_cache.get_result(:additive, index)
      @index = cached.resume_index if cached
      return cached
    end

    i0 = index
    failed_alternatives = []
    i1, s1 = index, []
    start_max_terminal_failure_last_index = max_terminal_failure_last_index
    local_max_terminal_failure_last_index = max_terminal_failure_last_index
    r2 = _nt_multitive
    local_max_terminal_failure_last_index = max_terminal_failure_last_index
    @max_terminal_failure_last_index = start_max_terminal_failure_last_index
    s1 << r2
    if r2 && !r2.is_a?(ParseFailure)
      start_max_terminal_failure_last_index = max_terminal_failure_last_index
      local_max_terminal_failure_last_index = max_terminal_failure_last_index
      r3 = _nt_space
      local_max_terminal_failure_last_index = max_terminal_failure_last_index
      @max_terminal_failure_last_index = start_max_terminal_failure_last_index
      s1 << r3
      if r3 && !r3.is_a?(ParseFailure)
        start_max_terminal_failure_last_index = max_terminal_failure_last_index
        local_max_terminal_failure_last_index = max_terminal_failure_last_index
        r4 = _nt_additive_op
        local_max_terminal_failure_last_index = max_terminal_failure_last_index
        @max_terminal_failure_last_index = start_max_terminal_failure_last_index
        s1 << r4
        if r4 && !r4.is_a?(ParseFailure)
          start_max_terminal_failure_last_index = max_terminal_failure_last_index
          local_max_terminal_failure_last_index = max_terminal_failure_last_index
          r5 = _nt_space
          local_max_terminal_failure_last_index = max_terminal_failure_last_index
          @max_terminal_failure_last_index = start_max_terminal_failure_last_index
          s1 << r5
          if r5 && !r5.is_a?(ParseFailure)
            start_max_terminal_failure_last_index = max_terminal_failure_last_index
            local_max_terminal_failure_last_index = max_terminal_failure_last_index
            r6 = _nt_additive
            local_max_terminal_failure_last_index = max_terminal_failure_last_index
            @max_terminal_failure_last_index = start_max_terminal_failure_last_index
            s1 << r6
          end
        end
      end
    end
    @max_terminal_failure_last_index = local_max_terminal_failure_last_index
    if !s1.last.is_a?(ParseFailure)
      r1 = (BinaryOperation).new(input, i1...index, s1)
      r1.extend(Additive0)
    else
      self.index = i1
      failure_range = (max_terminal_failure_last_index > input_length) ? (i1..max_terminal_failure_last_index) : (i1...max_terminal_failure_last_index)
      r1 = ParseFailure.new(failure_range)
      r1.dependencies.concat(s1)
    end
    if r1 && !r1.is_a?(ParseFailure)
      r0 = r1
      r0 = Propagation.new(r0)
    else
      failed_alternatives << r1
      r7 = _nt_multitive
      if r7 && !r7.is_a?(ParseFailure)
        r0 = r7
        r0 = Propagation.new(r0)
      else
        failed_alternatives << r7
        self.index = i0
        failure_range = (max_terminal_failure_last_index > input_length) ? (i0..max_terminal_failure_last_index) : (i0...max_terminal_failure_last_index)
        r0 = ParseFailure.new(failure_range)
      end
    end
    r0.dependencies.concat(failed_alternatives)

    expirable_result_cache.store_result(:additive, r0)

    return r0
  end

  module AdditiveOp0
    def apply(a, b)
      a + b
    end
  end

  module AdditiveOp1
    def apply(a, b)
      a - b
    end
  end

  def _nt_additive_op
    start_index = index
    if expirable_result_cache.has_result?(:additive_op, index)
      cached = expirable_result_cache.get_result(:additive_op, index)
      @index = cached.resume_index if cached
      return cached
    end

    i0 = index
    failed_alternatives = []
    if input.index('+', index) == index
      r1 = (SyntaxNode).new(input, index...(index + 1))
      r1.extend(AdditiveOp0)
      @index += 1
    else
      r1 = terminal_parse_failure('+', 1)
    end
    if r1 && !r1.is_a?(ParseFailure)
      r0 = r1
      r0 = Propagation.new(r0)
    else
      failed_alternatives << r1
      if input.index('-', index) == index
        r2 = (SyntaxNode).new(input, index...(index + 1))
        r2.extend(AdditiveOp1)
        @index += 1
      else
        r2 = terminal_parse_failure('-', 1)
      end
      if r2 && !r2.is_a?(ParseFailure)
        r0 = r2
        r0 = Propagation.new(r0)
      else
        failed_alternatives << r2
        self.index = i0
        failure_range = (max_terminal_failure_last_index > input_length) ? (i0..max_terminal_failure_last_index) : (i0...max_terminal_failure_last_index)
        r0 = ParseFailure.new(failure_range)
      end
    end
    r0.dependencies.concat(failed_alternatives)

    expirable_result_cache.store_result(:additive_op, r0)

    return r0
  end

  module Multitive0
    def operand_1
      elements[0]
    end

    def space
      elements[1]
    end

    def operator
      elements[2]
    end

    def space
      elements[3]
    end

    def operand_2
      elements[4]
    end
  end

  def _nt_multitive
    start_index = index
    if expirable_result_cache.has_result?(:multitive, index)
      cached = expirable_result_cache.get_result(:multitive, index)
      @index = cached.resume_index if cached
      return cached
    end

    i0 = index
    failed_alternatives = []
    i1, s1 = index, []
    start_max_terminal_failure_last_index = max_terminal_failure_last_index
    local_max_terminal_failure_last_index = max_terminal_failure_last_index
    r2 = _nt_primary
    local_max_terminal_failure_last_index = max_terminal_failure_last_index
    @max_terminal_failure_last_index = start_max_terminal_failure_last_index
    s1 << r2
    if r2 && !r2.is_a?(ParseFailure)
      start_max_terminal_failure_last_index = max_terminal_failure_last_index
      local_max_terminal_failure_last_index = max_terminal_failure_last_index
      r3 = _nt_space
      local_max_terminal_failure_last_index = max_terminal_failure_last_index
      @max_terminal_failure_last_index = start_max_terminal_failure_last_index
      s1 << r3
      if r3 && !r3.is_a?(ParseFailure)
        start_max_terminal_failure_last_index = max_terminal_failure_last_index
        local_max_terminal_failure_last_index = max_terminal_failure_last_index
        r4 = _nt_multitive_op
        local_max_terminal_failure_last_index = max_terminal_failure_last_index
        @max_terminal_failure_last_index = start_max_terminal_failure_last_index
        s1 << r4
        if r4 && !r4.is_a?(ParseFailure)
          start_max_terminal_failure_last_index = max_terminal_failure_last_index
          local_max_terminal_failure_last_index = max_terminal_failure_last_index
          r5 = _nt_space
          local_max_terminal_failure_last_index = max_terminal_failure_last_index
          @max_terminal_failure_last_index = start_max_terminal_failure_last_index
          s1 << r5
          if r5 && !r5.is_a?(ParseFailure)
            start_max_terminal_failure_last_index = max_terminal_failure_last_index
            local_max_terminal_failure_last_index = max_terminal_failure_last_index
            r6 = _nt_multitive
            local_max_terminal_failure_last_index = max_terminal_failure_last_index
            @max_terminal_failure_last_index = start_max_terminal_failure_last_index
            s1 << r6
          end
        end
      end
    end
    @max_terminal_failure_last_index = local_max_terminal_failure_last_index
    if !s1.last.is_a?(ParseFailure)
      r1 = (BinaryOperation).new(input, i1...index, s1)
      r1.extend(Multitive0)
    else
      self.index = i1
      failure_range = (max_terminal_failure_last_index > input_length) ? (i1..max_terminal_failure_last_index) : (i1...max_terminal_failure_last_index)
      r1 = ParseFailure.new(failure_range)
      r1.dependencies.concat(s1)
    end
    if r1 && !r1.is_a?(ParseFailure)
      r0 = r1
      r0 = Propagation.new(r0)
    else
      failed_alternatives << r1
      r7 = _nt_primary
      if r7 && !r7.is_a?(ParseFailure)
        r0 = r7
        r0 = Propagation.new(r0)
      else
        failed_alternatives << r7
        self.index = i0
        failure_range = (max_terminal_failure_last_index > input_length) ? (i0..max_terminal_failure_last_index) : (i0...max_terminal_failure_last_index)
        r0 = ParseFailure.new(failure_range)
      end
    end
    r0.dependencies.concat(failed_alternatives)

    expirable_result_cache.store_result(:multitive, r0)

    return r0
  end

  module MultitiveOp0
    def apply(a, b)
      a * b
    end
  end

  module MultitiveOp1
    def apply(a, b)
      a / b
    end
  end

  def _nt_multitive_op
    start_index = index
    if expirable_result_cache.has_result?(:multitive_op, index)
      cached = expirable_result_cache.get_result(:multitive_op, index)
      @index = cached.resume_index if cached
      return cached
    end

    i0 = index
    failed_alternatives = []
    if input.index('*', index) == index
      r1 = (SyntaxNode).new(input, index...(index + 1))
      r1.extend(MultitiveOp0)
      @index += 1
    else
      r1 = terminal_parse_failure('*', 1)
    end
    if r1 && !r1.is_a?(ParseFailure)
      r0 = r1
      r0 = Propagation.new(r0)
    else
      failed_alternatives << r1
      if input.index('/', index) == index
        r2 = (SyntaxNode).new(input, index...(index + 1))
        r2.extend(MultitiveOp1)
        @index += 1
      else
        r2 = terminal_parse_failure('/', 1)
      end
      if r2 && !r2.is_a?(ParseFailure)
        r0 = r2
        r0 = Propagation.new(r0)
      else
        failed_alternatives << r2
        self.index = i0
        failure_range = (max_terminal_failure_last_index > input_length) ? (i0..max_terminal_failure_last_index) : (i0...max_terminal_failure_last_index)
        r0 = ParseFailure.new(failure_range)
      end
    end
    r0.dependencies.concat(failed_alternatives)

    expirable_result_cache.store_result(:multitive_op, r0)

    return r0
  end

  module Primary0
    def space
      elements[1]
    end

    def expression
      elements[2]
    end

    def space
      elements[3]
    end

  end

  module Primary1
    def eval(env={})
      expression.eval(env)
    end
  end

  def _nt_primary
    start_index = index
    if expirable_result_cache.has_result?(:primary, index)
      cached = expirable_result_cache.get_result(:primary, index)
      @index = cached.resume_index if cached
      return cached
    end

    i0 = index
    failed_alternatives = []
    r1 = _nt_variable
    if r1 && !r1.is_a?(ParseFailure)
      r0 = r1
      r0 = Propagation.new(r0)
    else
      failed_alternatives << r1
      r2 = _nt_number
      if r2 && !r2.is_a?(ParseFailure)
        r0 = r2
        r0 = Propagation.new(r0)
      else
        failed_alternatives << r2
        i3, s3 = index, []
        start_max_terminal_failure_last_index = max_terminal_failure_last_index
        local_max_terminal_failure_last_index = max_terminal_failure_last_index
        if input.index('(', index) == index
          r4 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          r4 = terminal_parse_failure('(', 1)
        end
        local_max_terminal_failure_last_index = max_terminal_failure_last_index
        @max_terminal_failure_last_index = start_max_terminal_failure_last_index
        s3 << r4
        if r4 && !r4.is_a?(ParseFailure)
          start_max_terminal_failure_last_index = max_terminal_failure_last_index
          local_max_terminal_failure_last_index = max_terminal_failure_last_index
          r5 = _nt_space
          local_max_terminal_failure_last_index = max_terminal_failure_last_index
          @max_terminal_failure_last_index = start_max_terminal_failure_last_index
          s3 << r5
          if r5 && !r5.is_a?(ParseFailure)
            start_max_terminal_failure_last_index = max_terminal_failure_last_index
            local_max_terminal_failure_last_index = max_terminal_failure_last_index
            r6 = _nt_expression
            local_max_terminal_failure_last_index = max_terminal_failure_last_index
            @max_terminal_failure_last_index = start_max_terminal_failure_last_index
            s3 << r6
            if r6 && !r6.is_a?(ParseFailure)
              start_max_terminal_failure_last_index = max_terminal_failure_last_index
              local_max_terminal_failure_last_index = max_terminal_failure_last_index
              r7 = _nt_space
              local_max_terminal_failure_last_index = max_terminal_failure_last_index
              @max_terminal_failure_last_index = start_max_terminal_failure_last_index
              s3 << r7
              if r7 && !r7.is_a?(ParseFailure)
                start_max_terminal_failure_last_index = max_terminal_failure_last_index
                local_max_terminal_failure_last_index = max_terminal_failure_last_index
                if input.index(')', index) == index
                  r8 = (SyntaxNode).new(input, index...(index + 1))
                  @index += 1
                else
                  r8 = terminal_parse_failure(')', 1)
                end
                local_max_terminal_failure_last_index = max_terminal_failure_last_index
                @max_terminal_failure_last_index = start_max_terminal_failure_last_index
                s3 << r8
              end
            end
          end
        end
        @max_terminal_failure_last_index = local_max_terminal_failure_last_index
        if !s3.last.is_a?(ParseFailure)
          r3 = (SyntaxNode).new(input, i3...index, s3)
          r3.extend(Primary0)
          r3.extend(Primary1)
        else
          self.index = i3
          failure_range = (max_terminal_failure_last_index > input_length) ? (i3..max_terminal_failure_last_index) : (i3...max_terminal_failure_last_index)
          r3 = ParseFailure.new(failure_range)
          r3.dependencies.concat(s3)
        end
        if r3 && !r3.is_a?(ParseFailure)
          r0 = r3
          r0 = Propagation.new(r0)
        else
          failed_alternatives << r3
          self.index = i0
          failure_range = (max_terminal_failure_last_index > input_length) ? (i0..max_terminal_failure_last_index) : (i0...max_terminal_failure_last_index)
          r0 = ParseFailure.new(failure_range)
        end
      end
    end
    r0.dependencies.concat(failed_alternatives)

    expirable_result_cache.store_result(:primary, r0)

    return r0
  end

  module Variable0
    def eval(env={})
      env[name]
    end
    
    def name
      text_value
    end
  end

  def _nt_variable
    start_index = index
    if expirable_result_cache.has_result?(:variable, index)
      cached = expirable_result_cache.get_result(:variable, index)
      @index = cached.resume_index if cached
      return cached
    end

    s0, i0 = [], index
    r1 = nil
    loop do
      if input.index(Regexp.new('[a-z]'), index) == index
        r1 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        r1 = terminal_parse_failure('a-z', 1)
      end
      if r1 && !r1.is_a?(ParseFailure)
        s0 << r1
      else
        break
      end
    end
    if s0.empty?
      self.index = i0
      failure_range = (max_terminal_failure_last_index > input_length) ? (i0..max_terminal_failure_last_index) : (i0...max_terminal_failure_last_index)
      r0 = ParseFailure.new(failure_range)
    else
      r0 = SyntaxNode.new(input, i0...index, s0)
      r0.extend(Variable0)
    end
    r0.dependencies << r1

    expirable_result_cache.store_result(:variable, r0)

    return r0
  end

  module Number0
  end

  module Number1
    def eval(env={})
      text_value.to_i
    end
  end

  def _nt_number
    start_index = index
    if expirable_result_cache.has_result?(:number, index)
      cached = expirable_result_cache.get_result(:number, index)
      @index = cached.resume_index if cached
      return cached
    end

    i0 = index
    failed_alternatives = []
    i1, s1 = index, []
    start_max_terminal_failure_last_index = max_terminal_failure_last_index
    local_max_terminal_failure_last_index = max_terminal_failure_last_index
    if input.index(Regexp.new('[1-9]'), index) == index
      r2 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      r2 = terminal_parse_failure('1-9', 1)
    end
    local_max_terminal_failure_last_index = max_terminal_failure_last_index
    @max_terminal_failure_last_index = start_max_terminal_failure_last_index
    s1 << r2
    if r2 && !r2.is_a?(ParseFailure)
      start_max_terminal_failure_last_index = max_terminal_failure_last_index
      local_max_terminal_failure_last_index = max_terminal_failure_last_index
      s3, i3 = [], index
      r4 = nil
      loop do
        if input.index(Regexp.new('[0-9]'), index) == index
          r4 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          r4 = terminal_parse_failure('0-9', 1)
        end
        if r4 && !r4.is_a?(ParseFailure)
          s3 << r4
        else
          break
        end
      end
      r3 = SyntaxNode.new(input, i3...index, s3)
      r3.dependencies << r4
      local_max_terminal_failure_last_index = max_terminal_failure_last_index
      @max_terminal_failure_last_index = start_max_terminal_failure_last_index
      s1 << r3
    end
    @max_terminal_failure_last_index = local_max_terminal_failure_last_index
    if !s1.last.is_a?(ParseFailure)
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(Number0)
    else
      self.index = i1
      failure_range = (max_terminal_failure_last_index > input_length) ? (i1..max_terminal_failure_last_index) : (i1...max_terminal_failure_last_index)
      r1 = ParseFailure.new(failure_range)
      r1.dependencies.concat(s1)
    end
    if r1 && !r1.is_a?(ParseFailure)
      r0 = r1
      r0.extend(Number1)
      r0 = Propagation.new(r0)
    else
      failed_alternatives << r1
      if input.index('0', index) == index
        r5 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        r5 = terminal_parse_failure('0', 1)
      end
      if r5 && !r5.is_a?(ParseFailure)
        r0 = r5
        r0.extend(Number1)
        r0 = Propagation.new(r0)
      else
        failed_alternatives << r5
        self.index = i0
        failure_range = (max_terminal_failure_last_index > input_length) ? (i0..max_terminal_failure_last_index) : (i0...max_terminal_failure_last_index)
        r0 = ParseFailure.new(failure_range)
      end
    end
    r0.dependencies.concat(failed_alternatives)

    expirable_result_cache.store_result(:number, r0)

    return r0
  end

  def _nt_space
    start_index = index
    if expirable_result_cache.has_result?(:space, index)
      cached = expirable_result_cache.get_result(:space, index)
      @index = cached.resume_index if cached
      return cached
    end

    s0, i0 = [], index
    r1 = nil
    loop do
      if input.index(' ', index) == index
        r1 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        r1 = terminal_parse_failure(' ', 1)
      end
      if r1 && !r1.is_a?(ParseFailure)
        s0 << r1
      else
        break
      end
    end
    r0 = SyntaxNode.new(input, i0...index, s0)
    r0.dependencies << r1

    expirable_result_cache.store_result(:space, r0)

    return r0
  end

end

class ArithmeticParser < Treetop::Runtime::CompiledParser
  include Arithmetic
end
