require 'bundler/capistrano'
default_run_options[:pty] = true

set :application, "ccstb"
set :gitserver, "makestuffup.sourcerepo.com"
set :repository,  "git@makestuffup.sourcerepo.com:makestuffup/ccstb.git"
set :branch, "ccstb"

set :scm, :git
set :deploy_to, "/home/ccstbrai"
set :deploy_via, :remote_cache

ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "sourcerepo_ccstb_keys", "id_rsa")]

set :keep_releases, 3

set :domain, "69.25.136.6"
role :web, domain                    # Your HTTP server, Apache/etc
role :app, domain                    # This may be the same as your `Web` server
role :db, domain, :primary => true   # This is where Rails migrations will run

namespace :deploy do
  #task :start do ; end
  #task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
    run "curl -s http://db.ccstb.org $2 > /dev/null"
  end
end

namespace :db do
  desc "symlinks the database.yml file to the copy in the shared directory that is not under source control"
  task :symlink_yaml do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end

after "deploy:update_code", "db:symlink_yaml"
