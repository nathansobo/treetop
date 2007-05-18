command = '/usr/local/bin/ruby -I"/usr/local/lib/ruby/gems/1.8/gems/rspec-0.8.2/lib" "/usr/local/lib/ruby/gems/1.8/gems/rspec-0.8.2/bin/spec"'

prior_specs = ["spec/grammar/and_predicate_spec.rb", "spec/grammar/anything_symbol_spec.rb", "spec/grammar/character_class_spec.rb", "spec/grammar/grammar_builder_spec.rb", "spec/grammar/grammar_spec.rb", "spec/grammar/node_caching_spec.rb", "spec/grammar/nonterminal_parse_failure_forre_spec.rb", "spec/grammar/nonterminal_symbol_spec.rb", "spec/grammar/not_predicate_spec.rb", "spec/grammar/one_or_more_spec.rb", "spec/grammar/optional_spec.rb", "spec/grammar/ordered_choice_spec.rb", "spec/grammar/parsing_expression_builder_helper_spec.rb", "spec/grammar/parsing_expression_spec.rb", "spec/grammar/sequence_spec.rb", "spec/grammar/terminal_parse_failure_forre_spec.rb", "spec/grammar/terminal_symbol_spec.rb", "spec/grammar/zero_or_more_spec.rb", "spec/metagrammar/anything_symbol_rule_functional_spec.rb", "spec/metagrammar/block_rule_spec.rb", "spec/metagrammar/character_class_rule_functional_spec.rb", "spec/metagrammar/grammar_parser_functional_spec.rb", "spec/metagrammar/grammar_rule_functional_spec.rb", "spec/metagrammar/keyword_rule_functional_spec.rb"]

metacircular_spec = "spec/metagrammar/metacircular_functional_spec.rb"


puts `#{command} spec/metagrammar/anything_symbol_rule_functional_spec.rb #{metacircular_spec}`


# prior_specs.each do |prior_spec|
#   puts '----------'
#   puts prior_spec
#   puts `#{command} #{prior_spec} #{metacircular_spec}`
#   puts '----------'
# end