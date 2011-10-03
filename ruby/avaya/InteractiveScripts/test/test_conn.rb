require 'satconn'

class SatConn 
  attr_accessor :socket
end

describe SatConn do
  subject { SatConn.new(5022, "127.0.0.1", "dadmin", "dadmin", "dadmin1") }
  
  
  it 'Can be allocated with 5 parameters' do
    lambda { SatConn.new() }.should raise_error(ArgumentError)
    lambda { SatConn.new(10) }.should raise_error(ArgumentError)
    lambda { SatConn.new(10,20) }.should raise_error(ArgumentError)
    lambda { SatConn.new(10,20,30) }.should raise_error(ArgumentError)
    lambda { SatConn.new(10,20,30,40) }.should raise_error(ArgumentError)
    subject.should be_kind_of(subject.class)
    lambda { SatConn.new(10,20,30,40,50,60) }.should raise_error(ArgumentError)
  end
  
  context "with mocked object" do
    let(:object) { double() }
    let(:list_ext) { IO.read("test/resources/list_ext.raw") }
    
    before(:each) do
      subject.socket = object
    end
  
    it 'will close without problems' do 
      object.should_receive(:puts).with("logoff")
      object.should_receive(:waitfor).with({"String"=>"Proceed With Logoff:"})
      object.should_receive(:puts).with("y")
      object.should_receive(:close)
      subject.close
    end

    it 'will operate over list reg ext' do 
      object.should_receive(:puts).with("list reg e 2000")
      #object.should_receive(:waitfor).with({"String"=>"Command\:"}).return(list_ext)

      subject.list_reg(2000)
    end
  end
end
