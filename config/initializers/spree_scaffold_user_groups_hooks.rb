Deface::Override.new(:virtual_path => 'layouts/admin',
                     :name => 'add_UserGroup_model_to_tabs',
                     :insert_bottom => "[data-hook='admin_tabs']",
                     :text => '<%= tab(:user_groups) %>',
                     :disabled => false)
