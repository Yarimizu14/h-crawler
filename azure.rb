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
      find('.nav .ui-show-modal').click
      within(:css, '.ui-modal-contents-inner') do
        fill_in 'user[email]', with: ENV['EMAIL']
        fill_in 'user[password]', with: ENV['PASSWORD']
        click_on('ログイン')
      end
      save_screenshot 'screenshot.png'
    end

    def ff
      p "Index Project Listing Start"
      @crawls = []
      within(:css, '#container #main #project-index .projects-index-list') do
        index = 1
        all('article').each do |a|
          href = a.find('.project-title a')[:href]
          @crawls.push href if href
        end
        p @crawls
      end
      p "Index Project Listing End"
    end

    def crawl
      index = 1
      @crawls.each do |p|
        using_wait_time 5 do
          visit(p)
          index = index + 1
          # save_screenshot "screenshot-#{index}.png"
          File.open("result/wantedly-#{index}.html", 'w') do |f|
            f.puts page.html
          end
        end
      end
    end
  end
end

crawler = Crawler::Azure.new
crawler.login
crawler.ff
crawler.crawl
