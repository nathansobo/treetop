require 'benchmark'

dir = File.dirname(__FILE__)
require "#{dir}/../lib/treetop"
include Treetop

metagrammar_file_path = "#{dir}/../lib/treetop/metagrammar/metagrammar.treetop"
File.open(metagrammar_file_path, 'r') do |metagrammar_file|
  @parser = Metagrammar.new_parser

  # Benchmarking occurs here:
  puts(Benchmark.measure do
    result = @parser.parse(metagrammar_file.read)
  end)
end