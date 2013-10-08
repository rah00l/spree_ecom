Deface::Override.new(:virtual_path => 'layouts/admin',
                     :name => 'add_Category_model_to_tabs',
                     :insert_bottom => "[data-hook='admin_tabs']",
                     :text => '<%= tab(:categories) %>',
                     :disabled => false)
