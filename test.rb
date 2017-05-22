require 'rest_client'
require 'json'
require 'Nokogiri'
uri = "http://tktapi.melon.com/poc/ticketOpen/list.json?sortType=NEW&pageNo=1&v=1"
result = JSON.parse(RestClient.get(uri).body)

result["data"]["LIST"].each do |r|
  puts r["csoonId"]
  puts Time.parse(r["openDt"])
  puts r["title"]
  puts "http://cdnticket.melon.co.kr#{r["posterUrl"]}"
  puts "http://ticket.melon.com/csoon/detail.htm?csoonId=#{r["csoonId"]}"
  info = Nokogiri::HTML(r["infoPerf"])
  puts info.text
end
