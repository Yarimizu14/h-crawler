# coding: utf-8
require 'capybara'
require 'capybara/dsl'
require 'selenium-webdriver'

Capybara.run_server = false
Capybara.register_driver :selenium do |app|
  client = Selenium::WebDriver::Remote::Http::Default.new
  client.timeout = 30 # instead of the default 60
  Capybara::Selenium::Driver.new(app, :browser => :chrome, :driver_path => ENV['DRIVER_PATH'], args: ['--incognito'], http_client: client)
end
Capybara.current_driver = :selenium
Capybara.app_host = 'https://www.wantedly.com/'

module Crawler
  class Azure
    include Capybara::DSL

    def login
      using_wait_time 5 do
        visit('')
      end
      # fill_in 'login', with: 'hoge'
      # fill_in 'passwd', with: 'fuga'
      # click_button 'サインイン'
      find('.nav .ui-show-modal').click
      within(:css, '.ui-modal-contents-inner') do
        fill_in 'user[email]', with: ENV['EMAIL']
        fill_in 'user[password]', with: ENV['PASSWORD']
        click_on('ログイン')
      end
      save_screenshot 'screenshot.png'
    end

    def ff
      visit('')
      find '#wrapper'
      # find '#favoriteservice'
    end
  end
end

crawler = Crawler::Azure.new
# crawler.ff
crawler.login
