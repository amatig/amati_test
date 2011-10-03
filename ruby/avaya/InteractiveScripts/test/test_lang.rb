require "satlang"

describe SatLang do
  context "basically" do
    it "shouldn't be allocable" do
      lambda { SatLang.new }.should raise_error(NoMethodError)
    end
    it "should have method parse with one parameter" do
      SatLang.methods.grep(/parse/).should_not be_empty
      lambda {subject.parse()}.should raise_error(ArgumentError)
      lambda {subject.parse("a","b")}.should raise_error(ArgumentError)
    end
  end
  shared_examples_for "with set of input" do
    it "on method parse request should return an array of 3 elements" do  # [ :command, :response, :not_empty ]    
      input = list_ext
      subject.parse(input).should be_kind_of(Array)
      subject.parse(input).should have(3).items
    end
    it "on method parse with list reg e 2000 should return rigth data" do
      input = list_ext
      subject.parse(input).should be_kind_of(Array)
      subject.parse(input).should have(3).items
      subject.parse(input)[0].should ==("list registered-ip-stations ext 2000")
      subject.parse(input)[1].should ==("Command successfully completed")
      subject.parse(input)[2].should ==(false)
    end
    it "on method parse with busyout sta 2000 should return rigth data" do
      input = busy_out
      subject.parse(input).should be_kind_of(Array)
      subject.parse(input).should have(3).items
      subject.parse(input)[0].should ==("busyout station 2000")
      subject.parse(input)[1].should ==("Command successfully completed")
      subject.parse(input)[2].should ==(false)
    end
    it "on method parse with list reg on noreg station should return rigth data" do
      input = list_reg_norecord
      subject.parse(input).should be_kind_of(Array)
      subject.parse(input).should have(3).items
      subject.parse(input)[0].should ==("list registered-ip-stations ext 2000")
      subject.parse(input)[1].should ==("No records match the specified query options")
      subject.parse(input)[2].should ==(true)
    end
    it "on method parse with rel sta 2000 should return rigth data" do
      input = relsta
      subject.parse(input).should be_kind_of(Array)
      subject.parse(input).should have(3).items
      subject.parse(input)[0].should ==("release station 2000")
      subject.parse(input)[1].should ==("Command successfully completed")
      subject.parse(input)[2].should ==(false)
    end
    it "into the response each missing element will be marked nil" do
      input = empty_msg
      subject.parse(input).should be_kind_of(Array)
      subject.parse(input).should have(3).items
      subject.parse(input)[0].should ==(nil)
      subject.parse(input)[1].should ==(nil)
      subject.parse(input)[2].should ==(true)
    end
  end
  context "with regular input" do
    it_should_behave_like "with set of input" do
      let(:list_ext) { IO.read("test/resources/list_ext.raw") } 
      let(:busy_out) { IO.read("test/resources/busyout.raw") }
      let(:list_reg_norecord) { IO.read("test/resources/list_reg_norecord.raw") }
      let(:relsta) { IO.read("test/resources/relsta.raw") }
      let(:empty_msg) { "" }
    end
  end
  context "with comrpomised data from network" do   # NOTE it works well if no new line are added to input, multi empty line do not modify behaviour
    it_should_behave_like "with set of input" do
      let(:list_ext) { IO.read("test/resources/list_ext_ml.raw") } 
      let(:busy_out) { IO.read("test/resources/busyout_ml.raw") }
      let(:list_reg_norecord) { IO.read("test/resources/list_reg_norecord_ml.raw") }
      let(:relsta) { IO.read("test/resources/relsta_ml.raw") }
      let(:empty_msg) { "" }
    end
  end
end
