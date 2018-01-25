# coding: utf-8
require 'capybara'
require 'capybara/dsl'

require_relative '../page_scraper/company_page_scraper'
require_relative './company_stat_page_crawler'
require_relative './company_user_page_crawler'
require_relative '../model/company'

module Crawler

  class CompanyPageCrawler
    include Capybara::DSL

    def info
      @info ||= scrape_company_page(page.html, 'utf-8')
    end

    def save
      info = self.info
      c = Company.new(info)
      c.save!
      c.attributes
    end

    def visit_company_stat
      find('#company-show > div.two-column.cf > div.column-main.company_show > nav > ul > li:nth-child(5) > a').click
      using_wait_time 5 do p "visited #{page.current_path}" end
      CompanyStatPageCrawler.new
    end

    def visit_company_users
      find('#company-show > div.two-column.cf > div.column-main.company_show > nav > ul > li:nth-child(4) > a').click
      using_wait_time 5 do p "visited #{page.current_path}" end
      CompanyUserPageCrawler.new
    end
  end
end
