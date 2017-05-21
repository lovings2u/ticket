require 'nokogiri'
require 'open-uri'
require 'rest_client'

uri = "http://m.ticket.interpark.com/notice/open.html?&gr=01003"

result = Nokogiri::HTML(open(uri))
# result = RestClient.get uri

result.css('.open_list a').each do |r|
  puts r.css('dt').text
  puts "20#{r.css('dd').text}"
  # puts Time.parse(r.css('dd').text)
  uri = r['href']
  detail = Nokogiri::HTML(open(uri))
  puts uri
  puts detail.css('div.contents strong').text
  puts detail.css('img#mainPostImg')[0]['src']
  puts uri.split('=').last

  # puts detail.css('div.data').text
end
