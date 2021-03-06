# coding: utf-8
require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'selenium-webdriver'
require 'aws-sdk'
require 'active_record'

require_relative './model/project'
require_relative './page_crawlers/top_page_crawler'
require_relative './page_crawlers/project_page_crawler'
require_relative './db/connection'

headless = !!ENV['HEADLESS']

Capybara.register_driver :poltergeist do |app|
  driver = Capybara::Poltergeist::Driver.new(app, {
    debug: false,
    js_errors: false, # turn to true if raise erro on js_error
    timeout:  120
  })
  ua = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36'
  driver.headers = { 'User-Agent' => ua }
  driver
end

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome, driver_path:  ENV['DRIVER_PATH'], args: ['--incognito'])
end

Capybara.configure do |config|
  config.run_server = false
  driver = headless ? :poltergeist : :selenium
  config.default_driver = driver
  config.current_driver = driver
  config.app_host = 'https://www.wantedly.com/'
end

MAX_DEPTH = 2

module Crawler
  class Azure
    include Capybara::DSL

    def self.page_enjoy
      page_enjoy_time = rand(10) + 1
      sleep page_enjoy_time
    end

    def login
      using_wait_time 5 do
        visit('')
      end
      find('header .nav .ui-show-modal').click
      raise "environment variable EMAIL or PASSWORD is not defined." if ENV['EMAIL'].empty? || ENV['PASSWORD'].empty?
      within(:css, '.ui-modal-contents-inner') do
        fill_in 'user[email]', with: ENV['EMAIL']
        fill_in 'user[password]', with: ENV['PASSWORD']
        click_on('ログイン')
      end
    end

    def crawl
      top_crawler = Crawler::TopPageCrawler.new
      project_crawler = top_crawler.visit_first_project
      p project_crawler.info
      company_crawler = project_crawler.visit_company
      p company_crawler.info
      company_stat_crawler = company_crawler.visit_company_stat
      company_stat_crawler.each_company do |child_company|
        ret = self.crawl_company(child_company, 0)
        break if ret
      end
      return
      company_user_crawler = company_crawler.visit_company_users
      p company_user_crawler.info
      user_scrawler = company_user_crawler.visit_first_user
      p user_scrawler.info
    end

    def crawl_company(company_crawler, depth=0)
      using_wait_time 5 do
        company_crawler.ensure_load
      end
      unless company_crawler.can_save?
        p "skipping company #{company_crawler.id} because it can not be saved"
        return false
      end
      p "start to save company #{company_crawler.id}"
      p("failed to save company #{company_crawler.id}") && return unless company_crawler.save
      if depth > MAX_DEPTH
        p "exiting company #{company_crawler.id} because depth exceed"
        return false
      end
      depth = depth + 1
      company_stat_crawler = company_crawler.visit_company_stat
      company_stat_crawler.each_company do |child_company|
        ret = self.crawl_company(child_company, depth)
      end
      true
    end
  end
end

crawler = Crawler::Azure.new
crawler.login
crawler.crawl
