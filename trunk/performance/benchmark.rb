dir = File.dirname(__FILE__)
$:.unshift(File.join(dir, *%w[.. lib]))

require 'benchmark'
require "treetop"

include Treetop

metagrammar_file_path = File.join(dir, *%w[.. lib treetop metagrammar metagrammar.treetop])
File.open(metagrammar_file_path, 'r') do |metagrammar_file|
  @parser = Metagrammar.new_parser

  # Benchmarking occurs here:
  Benchmark.bm do |results|
    results.report do
      30.times do
        result = @parser.parse(metagrammar_file.read)
      end
    end
  end
end