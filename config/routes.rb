Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # get '/' => 'home#index', as: :home
  root 'home#index'
  get '/about' => 'home#about'
  resources :posts do
    resources :comments
    resources :favorites, only: [:create, :destroy]
  end

  resources :users, only: [:create, :new, :edit, :update] do
    resources :passwords, only: [:edit, :update]
    resources :favorites, only: [:index]
  end

  resources :sessions, only: [:create, :new] do
    delete :destroy, on: :collection
  end
end
