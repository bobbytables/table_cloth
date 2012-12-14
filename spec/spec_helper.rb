require 'table_cloth'
require 'awesome_print'
require 'nokogiri'
require 'factory_girl'
require 'pry'

Dir['./spec/support/**/*.rb'].each {|f| require f }

FactoryGirl.find_definitions

ActionView::Base.send :include, TableClothViewMocks

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
end