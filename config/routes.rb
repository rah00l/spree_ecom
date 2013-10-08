Mystore::Application.routes.draw do
  
  match 'orders/:product_id/see_price_in_cart' => "spree/orders#see_price_in_cart", as: :see_price_in_cart

  match 'products/:product_id/out_of_stock_notifier' => "spree/products#out_of_stock_notifier", as: :out_of_stock_notifier

  match 'products/update_states' => "spree/products#update_states", as: :update_states

  match 'admin/products/:product_id/select_products/:taxonomy_id' => "spree/admin/products#select_products", as: :select_products

  match 'admin/products/:taxonomy_id/remove_product_taxons/:product_id' => "spree/admin/products#remove_product_taxons", as: :remove_product_taxons

  match 'admin/products/:product_id/selected_product_taxons' => "spree/admin/products#selected_product_taxons", as: :selected_product_taxons

  match 'admin/products/:taxonomy_id/available_products_for_taxon' => "spree/admin/products#available_products_for_taxon", as: :available_products_for_taxon

  match 'admin/taxons/:taxonomy_id/products_for_selected_taxonomy' => "spree/admin/taxons#products_for_selected_taxonomy", as: :products_for_selected_taxonomy



  get "categories/index"

  get '/update_states' => 'user_registrations#update_states', :as => :update_states
  
  mount Spree::Core::Engine, :at => '/'
  # The priority is based upon order of creation:
  # first created -> highest priority.
	namespace :admin do
        resources :categories
        resources :user_groups
        resources :manufactures
       
    resources :taxonomies do
      member do
        get :get_children
      end

      resources :taxons
    end

#resources :reports  do
#      collection do
#        get :sales_total
#        get :products_min_max
#        post :low_stock
#      end
#    end

    end

match '/admin' => 'spree/admin/taxonomies#index', :as => :admin
#match '/admin' => 'admin/overview#index', :as => :admin

#match '/admin' => 'admin/taxonomies#index', as: :admin

match 'admin/reports/products_below_mimimum_quantity' => 'spree/admin/reports#products_below_mimimum_quantity' , as: :products_below_mimimum_quantity

match 'admin/reports/low_stock_report' => 'spree/admin/reports#low_stock_report' , as: :low_stock_report

match 'admin/reports/low_stock' => 'spree/admin/reports#low_stock' , as: :low_stock

match 'admin/reports/customer_report' => 'spree/admin/reports#customer_report' , as: :customer_report

match 'admin/reports/margin_report' => 'spree/admin/reports#margin_report' , as: :margin_report

match 'admin/reports/manufacture_sales_report' => 'spree/admin/reports#manufacture_sales_report' , as: :manufacture_sales_report

match 'admin/reports/referral_source_report' => 'spree/admin/reports#referral_source_report' , as: :referral_source_report


#  match 'admin/reports/products_below_mimimum_quantity' => "spree/admin/reports#products_below_mimimum_quantity", as: :products_below_mimimum_quantity
  
#  products_min_max_admin_reports



  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
  #root :to => 'spree/user_sessions#new'
end
