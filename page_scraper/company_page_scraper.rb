# coding: utf-8
require 'nokogiri'


def scrape_company_page(file_content, charset)
  # company_id = nil

  doc = Nokogiri::HTML.parse(file_content, nil, charset)

  # company name
  company_name = doc.css('#company-show > div.profile-header-wrapper > div.profile-header.cf > header > div.profile-name-top > h1 > a').first&.inner_text&.strip

  # member count
  # member_count_text = doc.css('#company-show > div.two-column.cf > div.column-main.company_show > nav > ul > li:nth-child(4) > a').first&.inner_text&.strip
  # member_count = /Members\s*\(([0-9]+)\)/.match(member_count_text)[1]
  member_count_text = doc.css('#company-show-main-area > div > section > ul > li:last-child > span').inner_text&.strip
  member_count = /([0-9]+)[\s\n]*[Mm]embers/.match(member_count_text)[1]

  # follower count
  follower_count_text = doc.css('#company-show > div.profile-header-wrapper > div.profile-header.cf > header > div.profile-name-bottom > div.follower-count').first&.inner_text&.strip
  follower_count = follower_count_text.to_i

  # founded_on
  founded_on = doc.css('#company-show-main-area > div > section > ul > li:nth-last-child(2) > span').first&.inner_text&.strip

  return {
      name: company_name,
      member_count: member_count,
      follower_count: follower_count,
      founded_on: founded_on,
  }
end
