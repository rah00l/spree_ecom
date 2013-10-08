Deface::Override.new(:virtual_path => 'layouts/admin',
                     :name => 'add_Manufacture_model_to_tabs',
                     :insert_bottom => "[data-hook='admin_tabs']",
                     :text => '<%= tab(:manufactures) %>',
                     :disabled => false)
