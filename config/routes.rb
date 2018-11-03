Rails.application.routes.draw do
  # UUID_CONSTRAINT = /[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}/

  root 'home#index'

  mount ActionCable.server => '/cable'

  get 'about',          to: 'about#index'
  get 'documentation',  to: 'documentation#index'
  get 'pricing',        to: 'pricing#index'
  get 'support',        to: 'support#index'

  post 'user_token', to: 'user_token#create'

  devise_for :users, class_name: 'Compendico::User'

  authenticate :user do
    resources :organizations, except: [:destroy] do
      resources :digests
      resources :templates
      resources :emails
      resources :tags, only: [:index]
    end

    resource :account, only: [:show, :edit, :update]
  end

  namespace :api do
    namespace :v1 do
      jsonapi_resources :digests
      jsonapi_resources :emails
      jsonapi_resources :messages
      jsonapi_resources :templates

      # constraints id: UUID_CONSTRAINT, message_id: UUID_CONSTRAINT, email_id: UUID_CONSTRAINT, email_address_id: UUID_CONSTRAINT do
      #   resources :email_addresses, except: [:new, :edit]
      #   resources :emails, except: [:new, :edit] do
      #     scope relationship: 'to_email_address', shallow: true do
      #       match 'relationships/to_email_address', action: :show_relationship,   via: [:get]
      #       match 'relationships/to_email_address', action: :create_relationship, via: [:post]
      #       match 'relationships/to_email_address', action: :update_relationship, via: [:put, :patch]
      #       match 'relationships/to_email_address', action: :delete_relationship, via: [:delete]
      #     end
      #     scope relationship: 'from_email_address', shallow: true do
      #       match 'relationships/from_email_address', action: :show_relationship,   via: [:get]
      #       match 'relationships/from_email_address', action: :create_relationship, via: [:post]
      #       match 'relationships/from_email_address', action: :update_relationship, via: [:put, :patch]
      #       match 'relationships/from_email_address', action: :delete_relationship, via: [:delete]
      #     end
      #     scope relationship: 'messages', shallow: true do
      #       match 'relationships/messages', action: :show_relationship,   via: [:get]
      #       match 'relationships/messages', action: :create_relationship, via: [:post]
      #       match 'relationships/messages', action: :update_relationship, via: [:put, :patch]
      #       match 'relationships/messages', action: :delete_relationship, via: [:delete]
      #     end
      #   end
      #   resources :messages, except: [:new, :edit] do
      #     scope relationship: 'emails', shallow: true do
      #       match 'relationships/emails', action: :show_relationship,   via: [:get]
      #       match 'relationships/emails', action: :create_relationship, via: [:post]
      #       match 'relationships/emails', action: :update_relationship, via: [:put, :patch]
      #       match 'relationships/emails', action: :delete_relationship, via: [:delete]
      #     end
      #   end
      # end
    end
  end
end
