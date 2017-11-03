# coding: utf-8
require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'selenium-webdriver'
require 'aws-sdk'

require_relative './model/project'

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
      # find('header .nav .ui-show-modal').trigger 'click'
      find('header .nav .ui-show-modal').click
      raise "environment variable EMAIL or PASSWORD is not defined." if ENV['EMAIL'].empty? || ENV['PASSWORD'].empty?
      within(:css, '.ui-modal-contents-inner') do
        fill_in 'user[email]', with: ENV['EMAIL']
        fill_in 'user[password]', with: ENV['PASSWORD']
        click_on('ログイン')
      end
      save_screenshot 'screenshot.png'
    end

    def find_projects
      p "Index Project Listing Start"
      @projects = []
      within(:css, '#container #main #project-index .projects-index-list') do
        all('article').each do |a|
          href = a.find('.project-title a')[:href]
          @projects.push href if href
        end
        p @projects
      end
      @projects = @projects.first(2)
      p "Index Project Listing End"
    end

    def crawl
      @projects.each do |p|
        using_wait_time 5 do
          visit(p)
          Azure.page_enjoy
          project_id = ''
          if m = page.current_path.match(/projects\/(?<project_id>\d+)/)
            project_id  = m[:project_id]
          end
          next if project_id.empty?
          File.open("result/wantedly-#{project_id}.html", 'w') do |f|
            f.puts page.html
          end
          p = Project.new
          p.insert(project_id)
        end
      end
    end

    def find_persons
      @users = []
      @projects.each do |p|
        using_wait_time 5 do
          visit(p)
          Azure.page_enjoy
          find(:xpath, '//*[@id="project-show-header"]/div[1]/hgroup/h2/a').trigger 'click'
          Azure.page_enjoy
          company_name = ''
          p "page.current_path ========> #{page.current_path}"
          if m = page.current_path.match(/companies\/(?<company_name>[a-zA-Z0-9]+)/)
            company_name  = m[:company_name]
          end
          p "company_name ========> #{company_name}"
          next if company_name.empty?
          File.open("result/wantedly-company-#{company_name}.html", 'w') do |f|
            f.puts page.html
          end

          # ========================================
          # =============== Employee ===============
          # ========================================

          visit("#{page.current_path}/employees")
          # find('#company-show > div.two-column.cf > div.column-main.company_show > div > div.employee-card-container').trigger 'click'
          p "page.current_path ========> #{page.current_path}"
          within(:css, '#company-show div.column-main.company_show div.employee-card-container') do
            all('.user-card').each do |a|
              href = a.find('a.wt-user')[:href]
              p "href ========> #{href}"
              @users.push href if href
            end
          end
        end
        p "users ========> #{@users}"
      end
    end

    def crawl_persons
      s3 = Aws::S3::Client.new(region: 'ap-northeast-1')
      @users =@users.first(2)
      @users.each do |p|
        using_wait_time 5 do
          visit(p)
          Azure.page_enjoy
          user_id = ''
          if m = page.current_path.match(/users\/(?<user_id>\d+)/)
            user_id  = m[:user_id]
          end
          next if user_id.empty?
          s3.put_object(bucket: 'hr-analysis-w', key: "html/user-#{user_id}.html", body: page.html)
        end
      end
    end
  end
end

crawler = Crawler::Azure.new
crawler.login
crawler.find_projects
crawler.find_persons
crawler.crawl_persons
