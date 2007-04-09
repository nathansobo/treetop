require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

context "The subset of the metagrammar rooted at the keyword rule" do
  include MetagrammarSpecContextHelper
  
  setup do
    @root = :keyword
  end
  
  specify "parses 'rule' and 'end' successfully" do
    with_both_protometagrammar_and_metagrammar do
      @parser.parse('end').should be_a_success
      @parser.parse('rule').should be_a_success
    end
  end
end