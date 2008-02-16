class TextraDocumentController < Rucola::RCWindowController
  ib_outlet :codeView
  attr_reader :codeView
  
  ib_outlet :irbView
  attr_reader :irbView
  
  attr_reader :document
  
  def awakeFromNib
    @document = TextraDocument.alloc.init(codeView.textStorage)
    puts "initialized doc"
    codeView.textStorage.setDelegate(document)
    puts "set delegate"
  end
  
  def windowDidLoad
  end
  
end