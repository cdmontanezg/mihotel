Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'application#index'
  post '/room/available' => 'room#available'
  post '/room/events' => 'room#events'
  resources :room, only: [:index, :show, :create, :destroy], defaults: {format: :json}
end