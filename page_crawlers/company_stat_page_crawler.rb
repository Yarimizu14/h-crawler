# coding: utf-8
require 'capybara'
require 'capybara/dsl'

require_relative '../page_scraper/company_stat_page_scraper'

module Crawler

  class CompanyStatPageCrawler
    include Capybara::DSL

    def info
      @info ||= scrape_company_stat_page(page.html, 'utf-8')
    end
  end

end
