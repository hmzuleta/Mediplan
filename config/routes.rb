Proyecto::Application.routes.draw do

  resources :controls
  resources :appointments
  resources :doctors
  resources :patients

  match "/login_admin" => redirect("/page/admin_login")
  match "/login_p" => redirect("/page/pat_login")
  match "/page/pat_page" => "page#pat_page"
  match "/page/pat_cancelar" => "page#pat_cancelar"
  match "/page/pat_selEsp" => "page#pat_selEsp"
  match "/page/pat_selCita" => "page#pat_selCita"
  match "/page/pat_reser" => "page#pat_reser"
  match "/pat_create" => "page#pat_create"
  match "/page/pat_create" => "page#pat_create"
  match "/page/pat_signup" => "page#pat_signup"

  match "/page/doc_page" => "page#doc_page"
  match "/page/doc_cancelar" => "page#doc_cancelar"

  match "/page/admin_addDoc" => "page#admin_addDoc"
  match "/page/admin_page" => "page#admin_page"
  match "/page/admin_insDoc" => "page#admin_insDoc"


  match "/logout" => "page#logout"

  match "/page/pat_selDispDoc" => "page#pat_selDispDoc"
  match "/login_m" => redirect("/page/doc_login")

  #Routes del admin
  get 'page/admin_login'
  post 'page/admin_page'
  post 'page/admin_generate'
  post 'page/admin_insDoc'
  post 'page/admin_addDoc'
  post 'page/admin_insCons'
  post 'page/admin_addCons'
  post '/page/admin_addOfficeDisp'
  post '/page/admin_resp_availability'

  #Routes del doctor
  get 'page/doc_login'
  post 'page/doc_page'
  post 'page/doc_add_availability'
  post 'page/doc_resp_availability'

  #Routes del patient
  get 'page/pat_login'
  get 'page/pat_page'
  post 'page/pat_spec'
  post 'page/pat_docs'
  post 'page/pat_cit'
  get 'page/pat_selDoc'
  get 'page/pat_selDispDoc'
  get 'page/pat_selEsp'
  post 'page/pat_create'

  root :to => 'page#index'

  # The priority is based upon order of creation:
  # first created -> highest priority.

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
  # match ':controller(/:action(/:id))(.:format)'
end
