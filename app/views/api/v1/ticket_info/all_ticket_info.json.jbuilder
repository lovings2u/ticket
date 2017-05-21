json.result_count @result[:result_count]
json.result do
  json.interpark_ticket do
    json.tickets @result[:interpark_ticket]
  end
  json.auction_ticket do
    json.tickets @result[:auction_ticket]
  end
  json.melon_ticket do
    json.tickets @result[:melon_ticket]
  end
  json.yes24_ticket do
    json.tickets @result[:yes24_ticket]
  end
end
