Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'application#index'
  get 'daypilot' => 'application#daypilot'
  resources :room, only: [:index, :show, :create, :destroy], defaults: {format: :json}
  resources :reservation, only: [:index, :show, :create, :destroy], defaults: {format: :json}
end