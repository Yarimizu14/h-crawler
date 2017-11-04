# coding: utf-8
require 'capybara'
require 'capybara/dsl'

require_relative '../page_scraper/company_users_page_scraper'
require_relative './user_page_crawler'

module Crawler

  class CompanyUserPageCrawler
    include Capybara::DSL

    def info
      @info ||= scrape_company_users_page(page.html)
    end

    def visit_first_user
      user_id = self.info.first
      visit("users/#{user_id}")
      using_wait_time 10 do p "visited #{page.current_path}" end
      UserPageCrawler.new
    end
  end
end
