require 'nokogiri'
require 'open-uri'
require 'rest_client'


uri = 'http://ticket.melon.com/csoon/ajax/listTicketOpen.htm'
params = {
  "pageIndex" => 1,
  "orderType" => 0
}
result = RestClient.post uri, params
result = Nokogiri::HTML(result)

result.css('span.date').each do |r|
  next unless r.text.start_with?("2017")
  puts Time.parse(r.text)
end
#
# result.css('a.tit').each do |r|
#   href = r['href'].gsub!('./','')
#   uri = "http://ticket.melon.com/csoon/" + href
#   detail = Nokogiri::HTML(open(uri))
#   info = detail.css('div.section_ticketopen_view')
#   puts "공연명 #{info.css('p.tit_consert').text}"
#   puts info.css('ul.data_txt').text
#   puts info.css('div.box_consert_thumb img')[0]['src']
# end
