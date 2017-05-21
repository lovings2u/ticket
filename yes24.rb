require 'rest_client'
require 'nokogiri'
require 'open-uri'
uri = 'http://ticket.yes24.com/Pages/Notice/Ajax/List.aspx'
params = {
  "page" => 1,
  "size" => 20,
  "genre" => 15456,
  "searchType" => "TIT",
  "order" => 1
}
result = Nokogiri::HTML(RestClient.post uri, params)

result.css('td.tit a').each do |a|
  # puts a.text + " || "+ a['href'].split('id=')[1]
  next if a.text.include?("취소")
  puts a.text
  url = 'http://ticket.yes24.com/Pages/Notice/NoticeMain.asp' + a['href']
  puts url
  uri = 'http://ticket.yes24.com/Pages/Notice/Ajax/Read.aspx'
  params = {
    "bid" => a['href'].split("id=")[1]
  }
  detail = Nokogiri::HTML(RestClient.post(uri, params))
  if detail.css('span#title1').text.include?("오후")
    time = Time.parse(detail.css('span#title1').text) + 12*60*60
  else
    time = Time.parse(detail.css('span#title1').text)
  end
  puts time
  puts detail.css('div.poster img')[0]['src']
  puts detail.css('div.content div.notic').text
end
