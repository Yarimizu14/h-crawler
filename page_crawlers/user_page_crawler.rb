# coding: utf-8
require 'capybara'
require 'capybara/dsl'
require 'active_record'

require_relative '../page_scraper/user_page_scraper'
Dir[File.dirname(__FILE__) + '/model/*.rb'].each {|file| require file }

module Crawler

  class UserPageCrawler
    include Capybara::DSL

    def info
      @info ||= scrape_user_page(page.html)
    end

    def save
      info = self.info
      ActiveRecord::Base.transaction do
        info.work_experiences.each do |c|
        end
        info.schools.each do |c|
        end
      end
    end
  end
end
