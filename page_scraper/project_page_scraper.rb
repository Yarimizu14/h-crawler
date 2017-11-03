# coding: utf-8
require 'nokogiri'

def scrape_project_page(file_content, charset)
  doc = Nokogiri::HTML.parse(file_content, nil, charset)

  # title
  title = doc.css('#project-show-header > div.project-show-title-wrapper > hgroup > h1').first&.inner_text&.strip

  # total view
  total_view = doc.css('#project-show-header > div.project-show-cover-wrapper > ul > li.total-views').first&.inner_text&.strip

  # published date
  publish_date = doc.css('#project-show-header > div.project-show-cover-wrapper > ul > li.published-date').first&.inner_text&.strip

  # recommendation
  recommendation = doc.css('#project-show-header > div.project-show-cover-wrapper > div.wt-ui-support-button > div.count.wt-support-count').first&.inner_text&.strip

  return {
      title: title,
      total_view: total_view,
      publish_date: publish_date,
      recommendation: recommendation,
  }
end
