Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :quests, only: [:create, :new, :show, :update]
  root to: 'quests#new'
end
