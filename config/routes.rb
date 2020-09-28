Rails.application.routes.draw do
  resources :test2s
  resources :tests
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    root 'home#index'
    namespace :v1 do
      get 'login',  to: 'session#login'
      post 'login', to: 'session#attempt_login'
      get 'logout', to: 'session#logout'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
