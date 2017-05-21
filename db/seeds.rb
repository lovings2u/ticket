# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# require 'nokogiri'
# require 'open-uri'
# require 'rest_client'
#
# def create_interpark_ticket_info
#   uri = "http://m.ticket.interpark.com/notice/open.html?&gr=01003"
#
#   result = Nokogiri::HTML(open(uri))
#   # result = RestClient.get uri
#
#   result.css('.open_list a').each do |r|
#     puts r.css('dt').text
#     puts "20#{r.css('dd').text}"
#     # puts Time.parse(r.css('dd').text)
#     uri = r['href']
#     detail = Nokogiri::HTML(open(uri))
#     Book.create(
#       concert_name: detail.css('div.contents strong').text,
#       open_date: Time.parse("20#{r.css('dd').text}"),
#       site_url: uri,
#       image_url: detail.css('img#mainPostImg')[0]['src'],
#       detail_info: detail.css('div.data').text,
#       source_site: 1,
#       tc_key: "1-#{uri.split('=').last}"
#     )
#   end
# end
#
def create_melon_ticket_info
  uri = 'http://ticket.melon.com/csoon/ajax/listTicketOpen.htm'
  params = {
    "pageIndex" => 1,
    "orderType" => 0
  }
  result = RestClient.post uri, params
  result = Nokogiri::HTML(result)

  result.css('a.tit').each do |r|
    href = r['href'].gsub!('./','')
    uri = "http://ticket.melon.com/csoon/" + href
    detail = Nokogiri::HTML(open(uri))
    info = detail.css('div.section_ticketopen_view')
    puts "공연명 #{info.css('p.tit_consert').text}"
    puts info.css('ul.data_txt').text
    puts info.css('div.box_consert_thumb img')[0]['src']
    Book.create(
      concert_name: info.css('p.tit_consert').text,
      site_url: uri,
      image_url: info.css('div.box_consert_thumb img')[0]['src'],
      detail_info: info.css('ul.data_txt').text,
      source_site: 2,
      tc_key: "2-#{uri.split('=').last}"
    )
  end
  count = -1
  book = Book.where(source_site: 2)
  result.css('span.date').each do |r|
    next unless r.text.start_with?("2017") & count+=1
    book[count].update(
      open_date: Time.parse(r.text)
    )
    puts r.text
  end
end
#
# def create_auction_ticket_info
#   uri = 'http://ticket1.auction.co.kr/Notice/List?Page=1'
#
#   result = Nokogiri::HTML(open(uri))
#
#   result.css('div.notice_list_box tr').each do |r|
#     next if r.css('td.cell2').text != "콘서트"
#     a_tag = r.css('td.cell3 a')
#     puts a_tag.text
#     uri = a_tag[0]['href'].split('\'')[5]
#     puts uri
#     if r.css('td.cell4').inner_text.include?("오후")
#       time = Time.parse(r.css('td.cell4').inner_text) + 60*60*12
#     else
#       time = Time.parse(r.css('td.cell4').inner_text)
#     end
#     detail = Nokogiri::HTML(open(uri))
#     info = detail.css('td.cell2')
#     # puts info[0].text.chomp
#     # puts info[1].text.chomp
#     # puts detail.css('td.cell4').text
#     puts detail.css('img.lazy')[0]['src']
#     d_info = detail.css('div.detail_info_block')[0].text + detail.css('div.detail_info_block')[1].text
#
#     puts d_info
#
#     Book.create(
#       concert_name: a_tag.text,
#       open_date: time,
#       site_url: uri,
#       image_url: detail.css('img.lazy')[0]['src'],
#       detail_info: d_info,
#       source_site: 3,
#       tc_key: "3-#{uri.split('=').last}"
#     )
#   end
# end
#
# def create_yes24_ticket_info
#   uri = 'http://ticket.yes24.com/Pages/Notice/Ajax/List.aspx'
#   params = {
#     "page" => 1,
#     "size" => 20,
#     "genre" => 15456,
#     "searchType" => "TIT",
#     "order" => 1
#   }
#   result = Nokogiri::HTML(RestClient.post uri, params)
#
#   result.css('td.tit a').each do |a|
#     # puts a.text + " || "+ a['href'].split('id=')[1]
#     next if a.text.include?("취소")
#     puts a.text
#     url = 'http://ticket.yes24.com/Pages/Notice/NoticeMain.asp' + a['href']
#     puts url
#     uri = 'http://ticket.yes24.com/Pages/Notice/Ajax/Read.aspx'
#     params = {
#       "bid" => a['href'].split("id=")[1]
#     }
#     detail = Nokogiri::HTML(RestClient.post(uri, params))
#     if detail.css('span#title1').text.include?("오후")
#       time = Time.parse(detail.css('span#title1').text) + 12*60*60
#     else
#       time = Time.parse(detail.css('span#title1').text)
#     end
#     puts time
#     puts detail.css('div.poster img')[0]['src']
#     puts detail.css('div.content div.notic').text
#     Book.create(
#       concert_name: a.text,
#       open_date: time,
#       site_url: url,
#       image_url: detail.css('div.poster img')[0]['src'],
#       detail_info: detail.css('div.content div.notic').text,
#       source_site: 4,
#       tc_key: "4-#{url.split('=').last}"
#     )
#   end
# end

Book.create_interpark_ticket_info
Book.create_melon_ticket_info
Book.create_auction_ticket_info
Book.create_yes24_ticket_info
