require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

module ParseFailureSpec
  include Runtime

  describe ParseFailure do
    it "returns the start index of its interval as its #resume_index" do
      failure = ParseFailure.new(3..6)
      failure.resume_index.should == 3
    end
  end
end