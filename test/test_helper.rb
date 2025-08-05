ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :rack_test

  # Helper to conditionally attach a file if the field exists
  def safe_attach_file(locator, path)
    attach_file(locator, path)
  rescue Capybara::ElementNotFound
    # ignore when the file input isn't present in simplified forms
  end
end
