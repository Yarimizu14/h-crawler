# coding: utf-8
require 'capybara'
require 'capybara/dsl'

require_relative '../page_scraper/company_page_scraper'
require_relative './company_stat_page_crawler'

module Crawler

  class CompanyPageCrawler
    include Capybara::DSL

    def info
      @info ||= scrape_company_page(pagepage.html, 'utf-8')
    end

    def visit_company_stat
      find('#company-show > div.two-column.cf > div.column-main.company_show > nav > ul > li:nth-child(5) > a').click
      using_wait_time 5 do p "visited #{page.current_path}" end
      CompanyStatPageCrawler.new
    end
  end
end
