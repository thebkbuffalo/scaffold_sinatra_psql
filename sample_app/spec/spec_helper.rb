ENV['RACK_ENV'] = 'test'
require 'rubygems'
require 'bundler'
Bundler.require(:default, ENV['RACK_ENV'])
require './config/boot'

# For multiple routes
config_routes = File.expand_path('../../config.ru', __FILE__)
Capybara.app = Rack::Builder.parse_file(config_routes).first
# # For single App
# Capybara.app = App
RSpec.configure do |config|
  config.include Capybara::DSL
end
