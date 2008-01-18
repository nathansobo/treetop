dir = File.dirname(__FILE__)
Dir.glob("#{dir}/**/*_spec.rb").each do |spec_file|
  require spec_file
end