dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/neometagrammar_spec_context_helper"

describe "The grammar node returned by Metagrammar's parsing of itself" do
  include NeometagrammarSpecContextHelper
  
  setup do
    @node = parse_metagrammar_with(NeometagrammarSpecContextHelper::Neometagrammar)
    @old_metagrammar = Metagrammar
  end
  
  after do
    Object.send(:remove_const, :Metagrammar)
    Metagrammar = @old_metagrammar
  end
  
  it "can generate Ruby whose evaluation creates a Metagrammar that can parse the file whence it came, producing a Metagrammar that can do the same thing again" do
    @node.should be_success

    eval(@node.to_ruby)
    Metagrammar.should_not == @old_metagrammar
    
    @node = parse_metagrammar_with(Metagrammar)
    @node.should be_success
    
    Object.send(:remove_const, :Metagrammar)
    eval(@node.to_ruby)
    Metagrammar.should_not == @old_metagrammar
  end
  
  def parse_metagrammar_with(grammar)
    metagrammar_file_path =
      File.expand_path('metagrammar.treetop', "#{File.dirname(__FILE__)}/../../lib/treetop/metagrammar/")

    File.open(metagrammar_file_path, 'r') do |file|
      return grammar.new_parser.parse(file.read)
    end
  end
end