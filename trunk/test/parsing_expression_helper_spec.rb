require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/spec_helper"

context "An object extended with the ParsingExpressionHelper module" do
  setup do
    @object = Object.new
    @object.extend ParsingExpressionHelper
  end
end