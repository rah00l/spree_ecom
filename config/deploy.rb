require "bundler/capistrano"

$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm"
require "rvm/capistrano"
set :rvm_ruby_string, 'ruby-1.9.3-p125@abshobbyzz'
set :rvm_type, :user  # Copy the exact line. I really mean :user here

set :rvm_path,          "/usr/local/rvm"
set :rvm_bin_path,      "#{rvm_path}/bin"
set :rvm_lib_path,      "#{rvm_path}/lib"


set :default_environment, {
  'PATH' => "/usr/local/rvm/gems/ruby-1.9.3-p125/bin:/usr/local/rvm/bin:/usr/local/rvm/rubies/ruby-1.9.3-p125/bin:$PATH",
  'RUBY_VERSION' => 'ruby-1.9.3-p125',
  'GEM_HOME'     => '/usr/local/rvm/gems/ruby-1.9.3-p125',
  'GEM_PATH'     => '/usr/local/rvm/gems/ruby-1.9.3-p125',
  'BUNDLE_PATH'  => '/usr/local/rvm/gems/ruby-1.9.3-p125'  # If you are using bundler.
}

set :domain ,'ah2.sparkway.com'
set :user, "root"
set :application, "absolutehobbyz"
set :repository, 'git@github.com:jozat/absolutehobbyz.git'
set :scm, :git
set :branch, "development"
set :scm_verbose, true
set :keep_releases, 5
set :deploy_via, :remote_cache
set :deploy_to, "/var/www/#{application}"
set :default_stage, 'production'
set :rails_env, "production"

set :normalize_asset_timestamps, false

role :app, domain
role :web, domain
role :db,  domain, :primary => true

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :runner, user

after "deploy:restart", "deploy:cleanup"

namespace :deploy do
  desc "Copy config files"
  after "deploy:update_code" do
    run "export RAILS_ENV=#{rails_env}"
    run "ln -nfs #{shared_path}/public/assets #{release_path}/public/assets"
    run "ln -nfs #{shared_path}/public/spree #{release_path}/public/spree"
#    run "ln -nfs #{shared_path}/doc/product_data #{release_path}/doc/product_data"
    run "ln -nfs #{shared_path}/log #{release_path}/log"
    run "ln -nfs #{shared_path}/tmp #{release_path}/tmp"
#    run "ln -nfs #{shared_path}/public/shipment_labels #{release_path}/public/shipment_labels"
    run "cp #{shared_path}/config/database.yml #{release_path}/config/"
    run "cp #{shared_path}/config/unicorn.rb #{release_path}/config/"
    #run "cp #{shared_path}/config/unicorn.rb #{release_path}/config/unicorn/#{rails_env}.rb"
    #sudo "chmod -R 0655 #{release_path}/tmp/"
    #sudo "chmod -R 0655 #{release_path}/public/spree/products"
    run "chmod -R 775 /var/www/absolutehobbyz/"
  end

#  task :restart, :roles => :app, :except => { :no_release => true } do
#    run "touch #{File.join(current_path,'tmp','restart.txt')}"
#  end

  desc "Zero-downtime restart of Unicorn"
  task :restart, :except => { :no_release => true } do
    run "kill -s USR2 `cat /var/www/absolutehobbyz/shared/pids/unicorn.pid`"
  end

  desc "Start unicorn"
  task :start, :except => { :no_release => true } do
    run "cd #{release_path} ; bundle exec unicorn_rails -c config/unicorn.rb -E #{rails_env} -D"
  end

  desc "Stop unicorn"
  task :stop, :except => { :no_release => true } do
    run "kill -s QUIT `cat /var/www/absolutehobbyz/shared/pids/unicorn.pid`"
  end


  desc "Seed the database"
  task :seed, :roles => :db do
    # on_rollback { deploy.db.restore }
    run "cd #{current_path}"
    run "rake db:seed RAILS_ENV=#{rails_env}"
    run "rake spree_sample:load RAILS_ENV=#{rails_env}"
  end

  desc 'run bundle install'
  task :bundle_install, :roles => :app do
    run "cd #{current_path} && bundle install --deployment --path #{shared_path}/bundle"
  end

  desc "Reset the database"
  task :reset, :roles => :db do
    # on_rollback { deploy.db.restore }
    run "cd #{current_path}"
    run "rake db:migrate:reset RAILS_ENV=#{rails_env}"
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
