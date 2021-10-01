Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'pages#home'
  resources :offers, only: [:index, :show, :edit, :create, :destroy] do
    collection do
      get :search
    end
  end
end
