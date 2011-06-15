require 'spec/spec_helper'

describe Genomer::RulesDSL do

  before(:each) do
    @dsl = Genomer::RulesDSL.new
  end

  describe "file attributes" do

    it "should include scaffold_file location" do
      @dsl.scaffold_file "location"
      @dsl.scaffold_file.should == "location"
    end

    it "should include sequence_file location" do
      @dsl.sequence_file "location"
      @dsl.sequence_file.should == "location"
    end

    it "should include out_file_name" do
      @dsl.out_file_name "name"
      @dsl.out_file_name.should == "name"
    end

    it "should include out_dir_name" do
      @dsl.out_dir_name "name"
      @dsl.out_dir_name.should == "name"
    end

    it "should include annotation_file location" do
      @dsl.annotation_file "location"
      @dsl.annotation_file.should == "location"
    end

  end

  describe "output types method" do

    it "should allow single output types to be set" do
      @dsl.output :type
      @dsl.output.should == [:type]
    end

    it "should allow multipe output types to be set" do
      @dsl.output :type1, :type2
      @dsl.output.should == [:type1, :type2]
    end

    it "should allow incremental addition of types" do
      @dsl.output :type1
      @dsl.output :type2
      @dsl.output.should == [:type1, :type2]
    end

  end

  describe "genome metadata methods" do

    it "should allow identifier to be set" do
      @dsl.identifier :type
      @dsl.identifier.should == :type
    end

    it "should allow description to be set" do
      @dsl.description :type
      @dsl.description.should == :type
    end

  end

  describe "annotation methods" do

    it "should allow map_annotations to be set" do
      @dsl.map_annotations :type
      @dsl.map_annotations.should == :type
    end

    it "should allow map_annotations to be set" do
      @dsl.annotation_id_field :type
      @dsl.annotation_id_field.should == :type
    end

  end

end
