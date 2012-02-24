require "bundler/capistrano"

set :application, "kayak"
set :repository,  "http://github.com/jsierles/kayak.git"
set :deploy_to, "/u/apps/#{application}"
set :scm, :git

set :user, "vagrant"
set :branch, "master"
set :deploy_type, 'deploy'
set :use_sudo, false

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

role :app, "kayak.test"
role :web, "kayak.test"
role :db,  "kayak.test", :primary => true

namespace :unicorn do
  desc "Start unicorn for this application"
  task :start do
    run "cd #{current_path} && bundle exec unicorn -c /etc/unicorn/kayak.conf.rb -D"
  end
end