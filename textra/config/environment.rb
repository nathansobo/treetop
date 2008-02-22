
Rucola::Initializer.run do |config|
  # Settings specified in environment/release.rb and environment/debug.rb take precident
  # over these settings.  
  #
  # Load any custom Objective-C frameworks
  # config.objc_frameworks = %w(webkit quartz iokit)
  #
  # Use active_record bindings
  # config.use_active_record = true
  #
  # In debug mode the Reloader will be used,
  # if you want to turn it off/on explicitely use:
  # config.use_reloader = false OR true
end