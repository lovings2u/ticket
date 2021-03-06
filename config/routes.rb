Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get '/get_servertime' => 'servertime#get_servertime'
      get '/all_ticket' => 'ticket_info#all_ticket_info'
      get '/search_ticket' => 'ticket_info#each_ticket_info'
      get '/tickets' => 'ticket_info#tickets'
      get '/one_ticket' => 'ticket_info#search_ticket'
      get '/search_by_name' => 'ticket_info#search_ticket_by_name'
      get '/update_info' => 'ticket_info#update_tickets'
    end
  end
end
