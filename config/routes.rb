Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: '/api/auth'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'application#index'
  resources :notification, only: [:index, :show, :create, :destroy], defaults: {format: :json}, path: '/api/notification'
  post '/api/room/available' => 'room#available', defaults: { format: :json }
  post '/room/create' => 'room#create', defaults: { format: :json }
  post '/api/reservation/events' => 'reservation#events', defaults: { format: :json }
  post '/api/reservation/resize' => 'reservation#resize', defaults: { format: :json }
  post '/api/reservation/move' => 'reservation#move', defaults: { format: :json }
  post '/api/reservation/delete' => 'reservation#delete', defaults: { format: :json }
  post '/api/reservation/create' => 'reservation#create', defaults: { format: :json }
  post '/api/reservation/retrieve' => 'reservation#retrieve', default: { format: :json }
  post '/api/reservation/update' => 'reservation#update', default: { format: :json }
  resources :room, only: [:index, :show, :create, :destroy], defaults: { format: :json }, path: '/api/room'
  resources :reservation, only: [:index, :show], defaults: {format: :json}, path: '/api/reservation'
end