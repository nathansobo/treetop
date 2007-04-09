module Treetop
  metagrammar_parser = Protometagrammar.new.new_parser
  
  File.open(File.expand_path('metagrammar.treetop', File.dirname(__FILE__)), 'r') do |file|
    metagrammar_text = file.read
    result = metagrammar_parser.parse(metagrammar_text)
    
    unless result.success?
      # result.failure_chains.each do |fc|
      #         puts fc.to_html
      #         
      #         puts '<hr/><pre>'
      #         puts metagrammar_text[fc.terminal_index..-1]
      #         puts '</pre><hr/>'
      #       end
      raise 'unable to parse metagrammar'
    end
    
    Metagrammar = result.value
  end
end