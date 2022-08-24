Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs', as: :swagger
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :invoices, only: %i[index show create update destroy]
      get 'invoices/qr/:id', to: 'invoices#show_qr'
      root to: 'invoices#index'
    end
  end
  root to: 'home#index'
end
