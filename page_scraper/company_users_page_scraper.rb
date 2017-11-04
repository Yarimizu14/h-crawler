# coding: utf-8
require 'nokogiri'


def scrape_company_users_page(file_content, charset = 'utf-8')
  doc = Nokogiri::HTML.parse(file_content, nil, charset)

  user_ids = []

  # TODO: handler lazy loading
  doc.css('#company-show > div.two-column.cf > div.column-main.company_show > div > div.employee-card-container .user-card').each do |node|
    user_path = node.css('.wt-user').attribute('href')&.value
    user_id = /^\/users\/([0-9]+).*$/.match(user_path)[1]&.to_i
    user_ids.push user_id
  end
  return user_ids
end
