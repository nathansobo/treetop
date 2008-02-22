require File.expand_path('../../test_helper', __FILE__)

describe 'TextraDocument' do
  before do
    @document = TextraDocument.alloc.init
  end

  it "should initialize" do
    @document.should.be.an.instance_of TextraDocument
    
    # You can also test if your attributes were set correctly in #after_init.
    # @document.some_attr.should == 'default'
  end
  
  it "should do stuff when a document is opened" do
    # Some example code of testing your #readFromFile_ofType method.
    # The same goes for the alternative open/write methods.
    #
    # path = '/some/path/to/a/textfile.txt'
    # File.expects(:read).with(path).returns('foo')
    # @document.readFromFile_ofType(path, '????')
  end
end