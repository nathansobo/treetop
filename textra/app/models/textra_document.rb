require 'pp'
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
    puts expiredRange
    
    node_cache = parser.send(:expirable_node_cache)
    node_index = node_cache.send(:node_index)
    
    parser.expire(expiredRange, changeInLength)
    parser.send(:input).replace(text)
    
    puts 'after expiry'
    pp node_index

    result = parser.reparse
    puts 'after reparse'
    pp node_index
    
    
    
    if result
      puts "true"
    else
      puts 'no reason' unless parser.failure_reason
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