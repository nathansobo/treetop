require File.expand_path('../../test_helper', __FILE__)

describe 'ApplicationController' do
  before do
    @controller = ApplicationController.alloc.init
  end
  
  it "should initialize" do
    @controller.should.be.an.instance_of ApplicationController
  end
  
  it "should set itself as the application delegate" do
    OSX::NSApp.expects(:delegate=).with(@controller)
    @controller.ib_outlet(:main_window).expects(:inspect)
    @controller.awakeFromNib
  end
  
  it "should do some stuff when the application has finished launching" do
    Kernel.expects(:puts)
    @controller.applicationDidFinishLaunching(nil)
  end
  
  it "should do some stuff when the application will terminate" do
    Kernel.expects(:puts)
    @controller.applicationWillTerminate(nil)
  end
end
