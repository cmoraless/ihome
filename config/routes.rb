Ihome::Application.routes.draw do
  
  get "sessions/new"
  
  resources :iboxes do
    resources :accessories
    resources :cameras
  end
  resources :cameras
  resources :accessory_types
  resources :ibox_accessories_containers
  resources :users do 
    resources :profiles
  end
  resources :home
  resources :homeadmin
  resources :admin
  resources :profiles do
    resources :schedules
  end
  resources :sessions
  resources :accessories
  resources :schedules
  get "log_out" => "sessions#destroy", :as => "log_out"
  get "log_in" => "sessions#new", :as => "log_in"
  get "sign_up" => "users#new", :as => "sign_up"
  root :to => "sessions#new"
  get "new_admin" => "users#newAdmin", :as => "new_admin"
  get "new_no_admin" => "users#newNoAdmin", :as => "new_no_admin"
  get "show_enable" => "iboxes#showEnable", :as => "show_enable"
  get "back_ibox" => "iboxes#back", :as => "back_ibox"
  get "back_user" => "users#back", :as => "back_user"
  get "back_camera" => "cameras#back", :as=>"back_camera"
  get "back_accessory" => "accessories#back", :as=>"back_accessory"
  get "back_accessory_types" => "accessory_types#back", :as=>"back_accessory_types"
  get "back_profile" => "profiles#back", :as => "back_profile"
  get "back_schedule" => "schedules#back", :as => "back_schedule"
  get "session_recover" => "sessions#recover", :as => "session_recover"
  get "destroy_accessory_unplugged" => "iboxes#destroyAccessory", :as => "destroy_accessory_unplugged"
  get "listen_to_add_accessory" => "iboxes#listenToAddAccessory", :as => "listen_to_add_accessory"
  get "listen_to_remove_accessory" => "iboxes#listenToRemoveAccessory", :as => "listen_to_remove_accessory"
  get "new_sensor_condition" => "iboxes#new_sensor_condition", :as => "new_sensor_condition"
  get "back_condition" => "iboxes#back_condition", :as => "back_condition"
  # The priority is based upon order of creation:
  
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):

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
	#root :to => 'start#index'
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
	match ':controller(/:action(/:id))(.:format)'	 
  match '/cameras/stream_image/:id' => "cameras#stream_image"
  match '/iboxes/reset/:id' => "iboxes#reset"
end
