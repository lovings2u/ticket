require 'rest_client'
require 'nokogiri'
require 'open-uri'

uri = 'http://ticket1.auction.co.kr/Notice/List?Page=1'

result = Nokogiri::HTML(open(uri))

result.css('div.notice_list_box tr').each do |r|
  next if r.css('td.cell2').text != "콘서트"
  a_tag = r.css('td.cell3 a')
  puts a_tag.text
  uri = a_tag[0]['href'].split('\'')[5]
  puts uri
  if r.css('td.cell4').inner_text.include?("오후")
    puts Time.parse(r.css('td.cell4').inner_text)
  else
    puts Time.parse(r.css('td.cell4').inner_text)
  end
  detail = Nokogiri::HTML(open(uri))
  info = detail.css('td.cell2')
  # puts info[0].text.chomp
  # puts info[1].text.chomp
  # puts detail.css('td.cell4').text
  puts detail.css('img.lazy')[0]['src']
  d_info = detail.css('div.detail_info_block')[0].text + detail.css('div.detail_info_block')[1].text

  puts d_info


end
