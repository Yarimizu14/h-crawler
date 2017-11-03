# coding: utf-8
require 'capybara'
require 'capybara/dsl'

require_relative '../page_scraper/project_page_scraper'
require_relative './company_page_crawler'

module Crawler

  class ProjectPageCrawler
    include Capybara::DSL

    def info
      @info ||= scrape_project_page(page.html, 'utf-8')
    end

    def save
    end

    def visit_company
      # TODO: retrieve company id
      find('#project-show-header > div.project-show-title-wrapper > hgroup > h2 > a').click
      using_wait_time 10 do p "visited #{page.current_path}" end
      CompanyPageCrawler.new
    end
  end

end
