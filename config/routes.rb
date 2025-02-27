require 'sidekiq/web'

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  root to: proc { [200, { 'Content-Type' => 'application/json' }, [{ message: 'API está ativa' }.to_json]] }

  mount_devise_token_auth_for 'User', at: 'auth'

  # Proteja a interface do Sidekiq com autenticação básica
  # authenticate :user, ->(u) { u.admin? } do
  #   mount Sidekiq::Web => '/sidekiq'
  # end

  # Exponha a interface do Sidekiq apenas uma vez
  mount Sidekiq::Web => '/sidekiq'

  resources :invoices, only: %i[index show create update destroy]
  resources :warranties, only: %i[index show create update destroy]
  resources :users, only: %i[index show create update destroy]
  resources :stores, only: %i[index show create update destroy]
  resources :products, only: %i[index show create update destroy]
end
