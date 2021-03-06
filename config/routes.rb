Privlock::Application.routes.draw do
  root 'home#index'

  get '/'    => 'home#index', as: :index
  get '/:id' => 'home#show',  as: :show, id: /[0-9]+/

  get '/page/:page'              => 'home#index'
  get '/categories/:category_id' => 'home#category_writings', as: :category_writings

  get '/admin/general' => 'admin#general', as: :admin_general

  get '/admin/categories' => 'admin#categories', as: :admin_categories


  resources :writings, except: [:index, :show]

  resources :categories, only: [] do
    resources :writings, only: :index
  end


  resources :categories, except: [:new, :show, :edit] do
    patch 'up',   on: :member
    patch 'down', on: :member
  end


  resources :writings, only: [] do
    resources :comments, except: [:new, :show, :edit] do
      get 'error', on: :collection
    end
  end

  resources :settings, only: :update, path: "/admin/general"


  devise_for :users


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
