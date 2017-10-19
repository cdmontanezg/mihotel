Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'application#index'
  resources :notification, only: [:index, :show, :create, :destroy], defaults: {format: :json}
  post '/room/available' => 'room#available', defaults: { format: :json }
  post '/reservation/events' => 'reservation#events', defaults: { format: :json }
  post '/reservation/resize' => 'reservation#resize', defaults: { format: :json }
  post '/reservation/move' => 'reservation#move', defaults: { format: :json }
  post '/reservation/delete' => 'reservation#delete', defaults: { format: :json }
  resources :room, only: [:index, :show, :create, :destroy], defaults: { format: :json }
end