require File.expand_path('../../test_helper', __FILE__)

describe 'TextraDocumentController' do
  before do
    @controller = TextraDocumentController.alloc.init
    
    # If this is a window controller belonging to a document model,
    # then this will allow you to mock the document.
    #
    # @document = mock('Document')
    # @controller.stubs(:document).returns(@document)
  end

  it "should initialize" do
    @controller.should.be.an.instance_of TextraDocumentController
  end
  
  it "should do stuff at awakeFromNib" do
    # Some example code of testing your #awakeFromNib.
    #
    # @document.expects(:some_method).returns('foo')
    # @controller.ib_outlet(:some_text_view).expects(:string=).with('foo')
    
    @controller.awakeFromNib
  end
end