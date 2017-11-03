# coding: utf-8
require 'nokogiri'

def scrape_company_stat_page(file_content, charset)
  work_also_company = [] # => []

  doc = Nokogiri::HTML.parse(file_content, nil, charset)

  # company name
  doc.css('#company-contents-wrapper .old-companies li').each do |node|
    org_path = node.css('a').first&.attribute('href')&.value
    org_id = /^\/org\/([0-9]+).*$/.match(org_path)[1]&.to_i
    company_name = node.css('a p').first&.inner_text&.strip

    count = node.css('a span').first&.inner_text&.strip
    work_also_company.push({
      org_id: org_id,
      company_name: company_name,
      count: count
    })
  end

  return work_also_company
end
