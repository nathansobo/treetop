class ApplicationController < Rucola::RCController
  ib_outlet :main_window
  attr_reader :textra_document_controller
  
  def awakeFromNib
    OSX::NSApp.delegate = self
    
    puts "ApplicationController awoke."
    puts "Edit: app/controllers/application_controller.rb"
    puts  "\nIts window is: #{@main_window.inspect}"
    
    @textra_document_controller = TextraDocumentController.alloc.init
    textra_document_controller.showWindow(self)
  end
  
  def applicationDidFinishLaunching(notification)
    Kernel.puts "\nApplication finished launching."
  end
  
  def applicationWillTerminate(notification)
    Kernel.puts "\nApplication will terminate."
  end
end