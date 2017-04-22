require 'HTTParty'
require 'Nokogiri'

page = 1
number = 1
while page <= 180 #TODO ページがハードコディング
  html_data = HTTParty.get("http://rdlp.jp/lp-archive/page/#{page}")
  thumbnails = Nokogiri::HTML(html_data).css('a.pmlink')

  thumbnails.each do |t|
    page_url = t.attributes['href'].value
    title = t.text.gsub!(" ",'').gsub!("\r\n",'')
    photo_url = t.css('.photo > img').first.attributes['src'].value
    p "#{number}. #{title}(img: #{photo_url}, url: #{page_url})"
    page_html = HTTParty.get(page_url)
    table = Nokogiri::HTML(page_html).search('table')
    rows = table.search('tr')
    rows.each do |tr|
      info = tr.elements.map(&:text).join(': ').gsub("\r\n", '').gsub(' ','')
      p info
    end
    number += 1
  end
  page += 1
end
