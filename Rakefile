# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")

require 'motion/project/template/ios'
require 'motion-env'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'CrashingPredicateWithFormat'
  app.frameworks += ['CoreData']
  app.vendor_project('vendor/CoreData', :static)

end
