Rails.application.routes.draw do

  post '/api/v1/register', :to => 'api/v1/users#create'
  post '/api/v1/transfers', :to => 'api/v1/transfers#create'
  post '/api/v1/transfers/:id/trips', :to => 'api/v1/trips#create'
  post '/api/v1/login', :to => 'api/v1/authentication#login'
  post '/api/v1/trips/:id/tickets/buy', :to => 'api/v1/tickets#buy'
  post '/api/v2/trips/:id/tickets/buy', :to => 'api/v2/tickets#buy'
  get '/api/v1/my-tickets', :to => 'api/v1/tickets#bought_tickets'
  get '/api/v1/my-profile', :to => 'api/v1/users#profile'
end
