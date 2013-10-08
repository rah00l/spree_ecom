	Deface::Override.new(:virtual_path => "spree/layouts/admin",
                       :name => 'product_imports',
                       :insert_bottom => "[data-hook='admin_tabs']",
                       :text => '<li class="<% if params[:controller] == "admin/product_imports" %>selected<% end %>"><a href="<%= main_app.admin_product_imports_path %>">Import Products</a></li>'
                       )