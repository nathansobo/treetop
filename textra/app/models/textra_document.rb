class TextraDocument < Rucola::RCDocument

  attr_reader :textStorage, :parser

  def init(textStorage)
    super
    @textStorage = textStorage
    @parser = ArithmeticParser.new
    parser.parse(text)
    self
  end
  
  def textStorageWillProcessEditing(notification)
    parser.expire(expiredRange, changeInLength)
    parser.send(:input).replace(text)
    if parser.reparse
      puts "true"
    else
      puts parser.failure_reason
    end
  end
  
  def expiredRange
    editedRange = textStorage.editedRange
    rangeLast = editedRange.location + editedRange.length - changeInLength
    editedRange.location..rangeLast
  end
  
  def changeInLength
    textStorage.changeInLength
  end
  
  def text
    textStorage.string.to_s
  end
  
  # marshalling
  def dataRepresentationOfType(aType)
    return nil
  end
  
  def loadDataRepresentation_ofType(data, aType)
    return true
  end
end