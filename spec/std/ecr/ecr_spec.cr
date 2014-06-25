#!/usr/bin/env bin/crystal --run
require "spec"
require "ecr"
require "ecr/macros"

class ECRSpecHelloView
  def initialize(@msg)
  end

  ecr_file "#{__DIR__}/../data/test_template.ecr"
end

describe "ECR" do
  it "builds a crystal program from a source" do
    program = ECR.process_string "hello <%= 1 %> wor\nld <% while true %> 2 <% end %>", "foo.cr"

    pieces = [
      %(String.build do |__str__|),
      %(__str__ << "hello ")
      %(__str__ << #<loc:"foo.cr",1,10> 1 )
      %(__str__ << " wor\\nld "),
      %(#<loc:"foo.cr",2,6> while true ),
        %(__str__ << " 2 "),
      %(#<loc:"foo.cr",2,25> end ),
      %(end),
    ]
    program.should eq(pieces.join "\n")
  end

  it "does ecr_file" do
    view = ECRSpecHelloView.new("world!")
    view.to_s.strip.should eq("Hello world! 012")
  end
end
