# coding: utf-8
require 'capybara'
require 'capybara/dsl'

require_relative './company_page_crawler'
require_relative '../page_scraper/company_stat_page_scraper'

module Crawler

  class CompanyStatPageCrawler
    include Capybara::DSL

    def info
      @info ||= scrape_company_stat_page(page.html, 'utf-8')
    end

    def each_company
      self.info.each do |el|
        yield CompanyPageCrawler.new(el[:org_id])
      end
    end
  end

end
