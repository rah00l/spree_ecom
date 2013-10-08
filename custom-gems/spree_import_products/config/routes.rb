Rails.application.routes.draw do
    namespace :admin do
      resources :product_imports, :only => [:index, :new, :create]
    end
    match 'admin/product_imports/download_file/:id', :controller=>'admin/product_imports', :action => 'download_file', :as => "product_imports_download_file"
    match 'admin/product_imports/log_file/:id', :controller=>'admin/product_imports', :action => 'log_file', :as => "product_imports_log_file"
    match 'admin/product_imports/destroy/:id', :controller=>'admin/product_imports', :action => 'destroy', :as => "destroy_product_imports"

  match 'admin/product_imports/build_export_file'=> "admin/product_imports#build_export_file", as: :build_export_file
end
