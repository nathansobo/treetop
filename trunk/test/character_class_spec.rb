require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/spec_helper"

context "A character class with the range A-Z" do
  setup do
    @terminal = CharacterClass.new('A-Z')
  end
  
  specify "matches single characters within that range" do
    @terminal.parse_at('A', 0, mock("parser")).should_be_success
    @terminal.parse_at('N', 0, mock("parser")).should_be_success
    @terminal.parse_at('Z', 0, mock("parser")).should_be_success    
  end
  
  specify "does not match single characters outside of that range" do
    @terminal.parse_at('8', 0, mock("parser")).should_be_failure
    @terminal.parse_at('a', 0, mock("parser")).should_be_failure    
  end
end