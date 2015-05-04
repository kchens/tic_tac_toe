Rails.application.routes.draw do

  root 'static#index'
  resources :game, only: [:create, :new, :edit]

end
