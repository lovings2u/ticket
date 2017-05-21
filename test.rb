require 'rest_client'

uri = "http://ticket.melon.com/csoon/detail.htm?csoonId=579"

result = RestClient.get(uri)

puts result.headers[:date]

file = File.open("time.txt", "wb")
file.write(result.headers[:date])
file.close

