# coding: utf-8
require 'capybara'
require 'capybara/dsl'

require_relative './project_page_crawler'

module Crawler

  class TopPageCrawler
    include Capybara::DSL

    def find_projects
      return @projects if @projects
      @projects = []
      within(:css, '#container #main #project-index .projects-index-list') do
        all('article').each do |a|
          href = a.find('.project-title a')[:href]
          project_id = ''
          if m = href.match(/projects\/(?<project_id>\d+)/)
            project_id  = m[:project_id]
          end
          @projects.push project_id if project_id
        end
        p @projects
      end
      @projects
    end

    def visit_first_project
      project_id = self.find_projects&.first
      visit("/projects/#{project_id}")
      using_wait_time 5 do p "visited #{page.current_path}" end
      ProjectPageCrawler.new
    end
  end

end
