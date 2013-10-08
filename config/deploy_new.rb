#require 'capistrano/ext/multistage'
require "bundler/capistrano"
require "rvm"
require "rvm/capistrano"

$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

set :rvm_ruby_string, 'ruby-1.9.3-p125@abshobbyz'
set :rvm_type, :user  # Copy the exact line. I really mean :user here

set :rvm_path,          "/usr/local/rvm"
set :rvm_bin_path,      "#{rvm_path}/bin"
set :rvm_lib_path,      "#{rvm_path}/lib"


set :default_environment, {
  'PATH' => "/usr/local/rvm/gems/ruby-1.9.2-p180/bin:/usr/local/rvm/bin:/usr/local/rvm/rubies/ruby-1.9.2-p290/bin:$PATH",
  'RUBY_VERSION' => 'ruby 1.9.2-p290',
  'GEM_HOME'     => '/usr/local/rvm/gems/ruby-1.9.2-p290',
  'GEM_PATH'     => '/usr/local/rvm/gems/ruby-1.9.2-p290@global',
  'BUNDLE_PATH'  => '/usr/local/rvm/gems/ruby-1.9.2-p290@global'  # If you are using bundler.
}

set :user, "deploy"
set :application, "youbuy"
set :repository, 'git@github.com:youbeauty/youbuy.git'
set :scm, :git
set :branch, "development"
set :scm_verbose, true
set :deploy_via, :remote_cache
set :keep_releases, 5
#set :deploy_via, :copy
set :deploy_to, "/home/deploy/rails_apps/#{application}"
set :use_sudo, true
#set :rvm_type, :user
set :stages, %w(development staging production)
set :default_stage, 'development'
set :normalize_asset_timestamps, false
set :shared_children,   %w(public/system log tmp/pids doc)

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :runner, user
#set :bundle_cmd, 'rvmsudo bundle'

after "deploy:restart", "deploy:cleanup"

namespace :deploy do
  desc "Copy config files"
  #
  after "deploy:update_code" do
    run "export RAILS_ENV=staging"
    run "ln -nfs #{shared_path}/public/assets #{release_path}/public/assets"
    run "ln -nfs #{shared_path}/public/spree #{release_path}/public/spree"
    run "ln -nfs #{shared_path}/public/labels_shipment #{release_path}/public/labels_shipment"
    run "ln -nfs #{shared_path}/public/shipment_labels #{release_path}/public"
    run "ln -nfs #{shared_path}/public/product_data #{release_path}/public/product_data"
#    run "ln -nfs #{shared_path}/doc/product_data #{release_path}/doc/product_data"
#    run "ln -nfs #{shared_path}/doc/product_data/ #{release_path}/doc/product_data/import_logs/"
    
    run "ln -nfs #{shared_path}/log #{release_path}/log"
    run "ln -nfs #{shared_path}/tmp #{release_path}/tmp"
    run "cp -R #{shared_path}/config/database.yml #{release_path}/config/"
    run "cp -R #{shared_path}/config/environments/staging.rb #{release_path}/config/environments/staging.rb"
    sudo "chmod -R 0777 #{release_path}/tmp/"
    sudo "chmod -R 0777 #{release_path}/public/labels_shipment"
    sudo "chmod -R 0777 #{release_path}/public/spree/products"
    sudo "chmod -R 0777 #{release_path}/public/product_data"
#    sudo "chmod -R 0777 #{release_path}/doc/product_data"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end


  desc "Seed the database"
  task :seed, :roles => :db do
    # on_rollback { deploy.db.restore }
    run "cd #{current_path}"
    run "rake db:seed RAILS_ENV=staging"
    run "rake spree_sample:load RAILS_ENV=staging"
  end
  
  desc 'run bundle install'
  task :bundle_install, :roles => :app do
    run "cd #{current_path} && bundle install --deployment --path #{shared_path}/bundle"
  end

  desc "Reset the database"
  task :reset, :roles => :db do
    # on_rollback { deploy.db.restore }
    run "cd #{current_path}"
    run "rake db:migrate:reset RAILS_ENV=staging"
  end

  task :cleanup do
    #do nothing
  end

end

after "deploy:create_symlink", "deploy:bundle_install"

namespace :bundler do
  task :create_symlink, :roles => :app do
    shared_dir = File.join(shared_path, 'bundle')
    release_dir = File.join(current_release, '.bundle')
    run("mkdir -p #{shared_dir} && ln -s #{shared_dir} #{release_dir}")
  end

  task :bundle_new_release, :roles => :app do
    bundler.create_symlink
    run "cd #{release_path} && source $HOME/.bash_profile && bundle install"
  end
end

#namespace :rvm do
#  task :trust_rvmrc do
#    run( "rvm rvmrc trust #{release_path}")
#  end
#end

after 'deploy:finalize_update', 'bundler:bundle_new_release'
#after "deploy", "rvm:trust_rvmrc"
