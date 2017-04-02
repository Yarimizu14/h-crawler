require 'anemone'
require 'nokogiri'
require 'kconv'

urls = [
  'https://www.amazon.co.jp/gp/bestsellers/books'
]

opts = {
  depth_limit: 0,
  skip_query_strings: true
}

Anemone.crawl(urls, opts) do |pages|

  pages.focus_crawl do |page|
    page.links.keep_if do |link|
      link.to_s.match(/\/gp\/bestsellers\/books/)
    end
  end

  pages.on_every_page do |page|
    puts page.url
    # puts page.doc
    doc = Nokogiri::HTML.parse(page.body.toutf8)

    items = doc.xpath("//div[@class=\"zg_itemRow\"]/div[1]/div[1]/div[2]")

    items.each do |item|
      # ranking
      puts item.xpath("div[1]/span[@class=\"zg_rankNumber\"]").text.strip
      # title
      puts item.xpath("a[@class=\"a-link-normal\"]/div").text.strip
    end
  end
end

