# frozen_string_literal: true

require 'bundler'
Bundler.setup

require 'minitest/autorun'
require 'selenium-webdriver'
require 'capybara'
require 'capybara/dsl'

# using capybara to easily test against a local app
Capybara.register_driver :headless_new do |app|
  # selenium will install the latest version of chrome and chromedriver if it
  # doesn't find it in the PATH.
  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: Selenium::WebDriver::Chrome::Options.new(
      args: %w[headless=new disable-gpu no-sandbox disable-dev-shm-usage]
    )
  )
end
Capybara.default_driver = :headless_new
Capybara.server_host = '0.0.0.0'
Capybara.server_port = '5001'
Capybara.server = :puma, { Silent: false }
Capybara.app = Rack::Builder.parse_file('./config.ru')

class IFrameDemoTest < Minitest::Test
  include Capybara::DSL
  ROOT = "http://#{Capybara.server_host}:#{Capybara.server_port}".freeze

  def selenium_driver
    page.driver.browser
  end

  def setup
    selenium_driver.navigate.to ROOT
  end

  def test_navigate_in_iframe
    selenium_driver.switch_to.frame 'inlineFrameExample'

    assert_equal '1', selenium_driver.find_element(:css, '#valueToRead').text

    selenium_driver.find_element(:css, '#next').click
    selenium_driver.find_element(:css, '#next').click

    assert_equal '3', selenium_driver.find_element(:css, '#valueToRead').text
  end

  def test_navigate_in_iframe_slow
    selenium_driver.switch_to.frame 'inlineFrameExample'
    assert_equal '1', selenium_driver.find_element(:css, '#valueToRead').text

    selenium_driver.find_element(:css, '#next-slow').click
    selenium_driver.find_element(:css, '#next-slow').click

    assert_equal '3', selenium_driver.find_element(:css, '#valueToRead').text
  end

  def test_navigate_with_no_iframe
    selenium_driver.navigate.to "#{ROOT}/frame/page/1"

    assert_equal '1', selenium_driver.find_element(:css, '#valueToRead').text

    selenium_driver.find_element(:css, '#next').click
    selenium_driver.find_element(:css, '#next').click

    assert_equal '3', selenium_driver.find_element(:css, '#valueToRead').text
  end

  def test_navigate_with_no_iframe_slow
    selenium_driver.navigate.to "#{ROOT}/frame/page/1"

    assert_equal '1', selenium_driver.find_element(:css, '#valueToRead').text

    selenium_driver.find_element(:css, '#next-slow').click
    selenium_driver.find_element(:css, '#next-slow').click

    assert_equal '3', selenium_driver.find_element(:css, '#valueToRead').text
  end
end
