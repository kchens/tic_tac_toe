Rails.application.routes.draw do

  root 'static#index'
  resources :game, only: [:index, :create, :new, :edit]

end
