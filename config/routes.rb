Rails.application.routes.draw do

  get '/auth/:provider/callback' => 'users#do_omniauth' , as: 'do_omniauth'
  post 'register' => 'users#do_register', as: 'do_register'
  get 'register' => 'users#register', as: 'register'
  get 'forget', controller: 'users', action: 'forget'
  post 'forget', controller: 'users', action: 'forget_notif'
  get 'reset/:token', controller: 'users', action: 'reset'
  patch 'reset/:token', controller: 'users', action: 'do_reset'
  get 'verify/:token', controller: 'users', action: 'verify'
  get 'verify_email/:token', controller: 'users', action: 'verify_email'
  get 'invited/:token', controller: 'users', action: 'invited'
  patch 'invited/:token', controller: 'users', action: 'do_invited'
  post 'login' => 'users#do_login', as: 'do_login'
  get 'login' => 'users#login', as: 'login'
  get 'logout' => 'users#logout', as: 'logout'
  get 'download' => 'download#index', as: 'download'
  post 'contact' => 'home#contact', as: 'contact'
  get 'home' => 'home#index', as: 'index'

  get '/:username', controller: 'dashboard', action: 'show'

  # chart route
  get '/:username/chart', controller: 'chart', action: 'show'

  # setting route
  get '/:username/setting(//:val)', controller: 'setting', action: 'show'
  patch '/:username/setting/profile', controller: 'setting', action: 'profile'
  post '/:username/setting/account/email/add', controller: 'setting', action: 'account_email_add'
  delete '/:username/setting/account/email/delete/:id', controller: 'setting', action: 'account_email_delete'
  get '/:username/setting/account/email/principal/:id', controller: 'setting', action: 'account_email_principal'
  get '/:username/setting/account/email/verify/:id', controller: 'setting', action: 'account_email_verify'
  patch '/:username/setting/account/password', controller: 'setting', action: 'account_ch_password'
  patch '/:username/setting/account/username', controller: 'setting', action: 'account_ch_username'
  delete '/:username/setting/account/delete', controller: 'setting', action: 'account_delete'
  get '/:username/setting/plan/upgrade/:id', controller: 'setting', action: 'plan_upgrade'
  post '/:username/setting/team/add', controller: 'setting', action: 'team_add'
  delete '/:username/setting/team/delete/:id', controller: 'setting', action: 'team_delete'
  patch '/:username/setting/key/generate', controller: 'setting', action: 'key_generate'

  # spaces route
  post '/:username/create', controller: 'spaces', action: 'create'
  get '/:username/spaces', controller: 'spaces', action: 'index'
  patch '/:username/:spacename', controller: 'spaces', action: 'edit'
  get '/:username/:spacename/setting', controller: 'spaces', action: 'setting'
  patch '/:username/:spacename/setting/change', controller: 'spaces', action: 'change'
  delete '/:username/:spacename/setting/delete', controller: 'spaces', action: 'delete'
  patch '/:username/:spacename/setting/transfer', controller: 'spaces', action: 'transfer'
  get '/:username/:spacename', controller: 'spaces', action: 'show'

  # projects route
  post '/:username/:spacename/create', controller: 'spaces', action: 'create'
  get '/:username/:spacename/projects', controller: 'projects', action: 'index'
  patch '/:username/:spacename/:projectname', controller: 'projects', action: 'edit'
  get '/:username/:spacename/:projectname/setting', controller: 'projects', action: 'setting'
  get '/:username/:spacename/:projectname/delete', controller:'projects', action: 'delete'
  get '/:username/:spacename/:projectname', controller: 'projects', action: 'show'

  root 'home#index'

  # at the end of you routes.rb
  get '*a', to: 'errors#routing'

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
