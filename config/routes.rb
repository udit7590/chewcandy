Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  
  # nimbleshop, spree, stripe, paypal, potionstore, acts_as_shopping_cart 
  root 'home#index'
  get 'heartbeat',  to: 'home#heartbeat'

  get 'about_us', to: 'home#about_us'
  get 'privacy_policy', to: 'home#privacy_policy'
  get 'terms_and_conditions', to: 'home#terms_and_conditions'

  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  devise_for :users, controllers: { 
                registrations: 'users/registrations', 
                sessions: 'users/sessions', 
                passwords: 'users/passwords'
              }, path: '', path_names: { sign_in: 'login' }

  resources :products

  scope '/discounts' do
    resources :criteria
  end
  resources :discounts

  resources :blog_posts, path: 'blog', concerns: :paginatable do
    get 'tags/:name', on: :collection, to: 'tags#show', as: :tagged
    resources :comments do
      post 'reply', to: 'comments#reply'
    end
  end

  get '/', constraints: { subdomain: 'blog' }, to: redirect('/blog')

  resource :shopping_cart, only: :show do
    get 'add/:product_id', to: 'shopping_carts#add', as: :add_to
    get 'remove/:product_id', to: 'shopping_carts#remove', as: :remove_from
    get 'empty', to: 'shopping_carts#empty', as: :empty
  end

  resources :orders, except: [:edit, :update, :new, :create], concerns: :paginatable do
    get :checkout, to: 'orders#checkout', as: :checkout, on: :collection
    post :place, to: 'orders#place', as: :place, on: :collection
    post 'change_state/:new_state', to: 'orders#change_state', as: :change_state, on: :member
    get :check_coupon, to: 'orders#check_coupon', as: :validate_coupon, on: :collection

    # Index Filters
    get 'filter/:by', to: 'orders#filter', on: :collection, as: :filter
  end

  # UDIT- UNCOMMENT WHEN SUBSCRIPTION REQUIRED
  # resources :subscriptions, except: [:edit, :update, :destroy, :new, :create], concerns: :paginatable do
  #   get 'new/:plan_id', to: 'subscriptions#new', on: :collection, as: :new
  #   post 'create/:plan_id', to: 'subscriptions#create', on: :collection, as: :create
    
  #   post 'dispatch_box/:subscription_id', to: 'subscriptions#dispatch_box', on: :collection, as: :dispatch_box

  #   # Index Filters
  #   get 'filter/:by', to: 'subscriptions#filter', on: :collection, as: :filter
  # end

  # resources :subscription_details, only: [] do
  #   patch 'deliver', to: 'subscription_details#deliver', on: :member, as: :deliver
  #   get 'receive_payment', to: 'subscription_details#receive_payment', on: :member, as: :receive_payment
  #   patch 'payment_received', to: 'subscription_details#payment_received', on: :member, as: :payment_received
  # end

  resources :refunds, except: [:edit, :update, :destroy, :new, :create], concerns: :paginatable do
    post 'complete', to: 'refunds#complete', on: :member, as: :complete
    get 'filter/:by', to: 'refunds#filter', on: :collection, as: :filter
  end

  post 'feedback', to: 'users/feedbacks#send_feedback'
  resources :enquiries, only: [:create, :index]
  # post 'newsletter', to: 'users/newsletter#signup'

  namespace :users do
    resources :orders, only: [:index, :show] do
      patch :cancel, to: 'orders#cancel', as: :cancel, on: :member
      patch :refund, to: 'orders#refund', as: :refund, on: :member
    end
    # UDIT- UNCOMMENT WHEN SUBSCRIPTION REQUIRED
    # resources :subscriptions, only: [:index, :show] do
    #   patch :cancel, to: 'subscriptions#cancel', as: :cancel, on: :member
    # end
    resource :account, only: [:edit, :update]
    resources :refunds, only: [:index, :create]
  end

  get '/:candy_name', to: 'home#index', as: :my_candy
end
