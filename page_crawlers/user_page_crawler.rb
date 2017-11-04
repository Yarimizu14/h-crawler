# coding: utf-8
require 'capybara'
require 'capybara/dsl'

require_relative '../page_scraper/user_page_scraper'

module Crawler

  class UserPageCrawler
    include Capybara::DSL

    def info
      @info ||= scrape_user_page(page.html)
    end
  end

end
