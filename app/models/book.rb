class Book < ApplicationRecord
  validates :tc_key, uniqueness: true

  require 'nokogiri'
  require 'open-uri'
  require 'rest_client'

  def self.update_info
    original_count = Book.all.count
    Book.create_interpark_ticket_info
    Book.create_auction_ticket_info
    Book.create_melon_ticket_info
    Book.create_yes24_ticket_info
    result_count = Book.all.count
    puts "#{original_count - result_count} tickets Created!"
    "#{original_count - result_count} tickets Created!"
  end

  def self.create_interpark_ticket_info
    uri = "http://m.ticket.interpark.com/notice/open.html?&gr=01003"

    result = Nokogiri::HTML(open(uri))
    # result = RestClient.get uri

    result.css('.open_list a').each do |r|
      puts r.css('dt').text
      # puts Time.parse(r.css('dd').text)
      uri = r['href']
      detail = Nokogiri::HTML(open(uri))
      begin
        Book.create(
          concert_name: detail.css('div.contents strong').text,
          open_date: Time.parse("20#{r.css('dd').text}"),
          site_url: uri,
          image_url: detail.css('img#mainPostImg')[0]['src'],
          detail_info: detail.css('div.data').text,
          source_site: 1,
          tc_key: "1-#{uri.split('=').last}"
        )
      rescue
        next
      end
    end
  end

  def self.create_melon_ticket_info
    uri = "http://tktapi.melon.com/poc/ticketOpen/list.json?sortType=NEW&pageNo=1&v=1"
    result = JSON.parse(RestClient.get(uri).body)

    result["data"]["LIST"].each do |r|
      info = Nokogiri::HTML(r["infoPerf"])
      puts r["title"]
      begin
        Book.create(
          concert_name: r["title"],
          open_date: Time.parse(r["openDt"]),
          image_url: "http://cdnticket.melon.co.kr#{r["posterUrl"]}",
          site_url: "http://ticket.melon.com/csoon/detail.htm?csoonId=#{r["csoonId"]}",
          detail_info: info.text,
          source_site: 2,
          tc_key: "2-#{r['csoonId']}"
        )
      rescue
        next
      end
    end
    # uri = 'http://ticket.melon.com/csoon/ajax/listTicketOpen.htm'
    # params = {
    #   "orderType" => "0",
    #   "pageIndex" => "1",
    #   "schText" => ""
    # }
    # headers = {
    #   "Accept" => "*/*",
    #   "Accept-Encoding" => "gzip, deflate",
    #   "Accept-Language" => "ko-KR,ko;q=0.8,en-US;q=0.6,en;q=0.4",
    #   "Connection" => "keep-alive",
    #   "Content-Length" => "32",
    #   "Content-Type" => "application/x-www-form-urlencoded",
    #   "charset" => "UTF-8",
    #   "Cookie" => "SCOUTER=z5gppkos3df67t; PCID=14951734126572201067300; WMONID=Df9CR6RuzEU; TKT_POC_ID=MP15",
    #   "Host" => "ticket.melon.com",
    #   "Origin" => "http://ticket.melon.com",
    #   "Referer" => "http://ticket.melon.com/csoon/index.htm",
    #   "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36",
    #   "X-Requested-With" =>"XMLHttpRequest"
    # }
    # result = RestClient.post uri, params, headers
    # result = Nokogiri::HTML(result)
    #
    # result.css('a.tit').each do |r|
    #   href = r['href'].gsub!('./','')
    #   uri = "http://ticket.melon.com/csoon/" + href
    #   detail = Nokogiri::HTML(open(uri))
    #   info = detail.css('div.section_ticketopen_view')
    #   puts "#{info.css('p.tit_consert').text}"
    #   Book.create(
    #     concert_name: info.css('p.tit_consert').text,
    #     site_url: uri,
    #     image_url: info.css('div.box_consert_thumb img')[0]['src'],
    #     detail_info: info.css('ul.data_txt').text,
    #     source_site: 2,
    #     tc_key: "2-#{uri.split('=').last}"
    #   )
    # end
    # count = -1
    # book = Book.where(source_site: 2)
    # result.css('span.date').each do |r|
    #   next unless r.text.start_with?("2017") & count+=1
    #   book[count].update(
    #     open_date: Time.parse(r.text)
    #   )
    #   puts r.text
    # end
  end

  def self.create_auction_ticket_info
    uri = 'http://ticket1.auction.co.kr/Notice/List?Page=1'

    result = Nokogiri::HTML(open(uri))

    result.css('div.notice_list_box tr').each do |r|
      next if r.css('td.cell2').text != "콘서트"
      a_tag = r.css('td.cell3 a')
      puts a_tag.text
      uri = a_tag[0]['href'].split('\'')[5]
      begin
      if r.css('td.cell4').inner_text.include?("오후")
        time = Time.parse(r.css('td.cell4').inner_text) + 60*60*12
      else
        time = Time.parse(r.css('td.cell4').inner_text)
      end
      detail = Nokogiri::HTML(open(uri))
      info = detail.css('td.cell2')
      # puts info[0].text.chomp
      # puts info[1].text.chomp
      # puts detail.css('td.cell4').text
      d_info = detail.css('div.detail_info_block')[0].text + detail.css('div.detail_info_block')[1].text
        Book.create(
          concert_name: a_tag.text,
          open_date: time,
          site_url: uri,
          image_url: detail.css('img.lazy')[0]['src'],
          detail_info: d_info,
          source_site: 3,
          tc_key: "3-#{uri.split('=').last}"
        )
      rescue
        next
      end
    end
  end

  def self.create_yes24_ticket_info
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
      url = 'http://ticket.yes24.com/Pages/Notice/NoticeMain.aspx' + a['href']
      uri = 'http://ticket.yes24.com/Pages/Notice/Ajax/Read.aspx'
      params = {
        "bid" => a['href'].split("id=")[1]
      }
      begin
      detail = Nokogiri::HTML(RestClient.post(uri, params))
      if detail.css('span#title1').text.include?("오후")
        time = Time.parse(detail.css('span#title1').text) + 12*60*60
      else
        time = Time.parse(detail.css('span#title1').text)
      end
        Book.create(
          concert_name: a.text,
          open_date: time,
          site_url: url,
          image_url: detail.css('div.poster img')[0]['src'],
          detail_info: detail.css('div.content div.notic').text,
          source_site: 4,
          tc_key: "4-#{url.split('=').last}"
        )
      rescue
        next
      end
    end
  end
end
