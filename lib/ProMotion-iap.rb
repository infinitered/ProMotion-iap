# encoding: utf-8

unless defined?(Motion::Project::Config)
  raise "ProMotion-iap must be required within a RubyMotion project."
end

Motion::Project::App.setup do |app|
  lib_dir_path = File.dirname(File.expand_path(__FILE__))
  app.files.unshift File.join(lib_dir_path, "project/product.rb")
  app.files.unshift File.join(lib_dir_path, "project/iap.rb")
  app.frameworks << "StoreKit"
end
