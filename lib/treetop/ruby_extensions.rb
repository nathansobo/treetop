dir = File.dirname(__FILE__)
Dir.glob("#{dir}/ruby_extensions/*.rb").each do |file|
	require file
end
