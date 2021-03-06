require File.dirname(__FILE__) + '/story_helper'

module Spec
  module Story
    describe StepMatcher do
      it "should match a text string" do
        step_matcher = StepMatcher.new("this text") {}
        step_matcher.matches?("this text").should be_true
      end
      
      it "should match a text string with a param" do
        step_matcher = StepMatcher.new("this $param text") {}
        step_matcher.matches?("this anything text").should be_true
      end
      
      it "should match a text string with 3 params" do
        step_matcher = StepMatcher.new("1 $one 2 $two 3 $three 4") {}
        step_matcher.matches?("1 a 2 b 3 c 4").should be_true
      end
      
      it "should match a text string with a param at the beginning" do
        step_matcher = StepMatcher.new("$one 2 3") {}
        step_matcher.matches?("a 2 3").should be_true
      end
      
      it "should match a text string with a param at the end" do
        step_matcher = StepMatcher.new("1 2 $three") {}
        step_matcher.matches?("1 2 c").should be_true
      end
      
      it "should not match a different string" do
        step_matcher = StepMatcher.new("this text") {}
        step_matcher.matches?("other text").should be_false
      end

      it "should match a regexp" do
        step_matcher = StepMatcher.new(/this text/) {}
        step_matcher.matches?("this text").should be_true
      end
      
      it "should match a regexp with a match group" do
        step_matcher = StepMatcher.new(/this (.*) text/) {}
        step_matcher.matches?("this anything text").should be_true
      end
      
      it "should not match a non matching regexp" do
        step_matcher = StepMatcher.new(/this (.*) text/) {}
        step_matcher.matches?("other anything text").should be_false
      end
      
      it "should make complain with no block" do
        lambda {
          step_matcher = StepMatcher.new("foo")
        }.should raise_error
      end
      
      it "should perform itself on an object" do
        # given
        $instance = nil
        step = StepMatcher.new 'step' do
          $instance = self
        end
        instance = Object.new
        
        # when
        step.perform(instance, "step")
        
        # then
        $instance.should == instance
      end
      
      it "should perform itself with one parameter" do
        # given
        $result = nil
        step = StepMatcher.new 'an account with $count dollars' do |count|
          $result = count
        end
        instance = Object.new
        
        # when
        step.perform(instance, "an account with 3 dollars")
        
        # then
        $result.should == "3"
      end
      
      it "should perform itself with 2 parameters" do
        # given
        $account_type = nil
        $amount = nil
        step = StepMatcher.new 'a $account_type account with $amount dollars' do |account_type, amount|
          $account_type = account_type
          $amount = amount
        end
        instance = Object.new
        
        # when
        step.perform(instance, "a savings account with 3 dollars")
        
        # then
        $account_type.should == "savings"
        $amount.should == "3"
      end
    end
  end
end
