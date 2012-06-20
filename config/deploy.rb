require "bundler/capistrano"
require 'fast_git_deploy/enable'

set :application, "kayak"
set :repository,  "http://github.com/jsierles/kayak.git"

set :user, "vagrant"
set :use_sudo, false
set :deploy_type, :deploy
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
ssh_options[:keys] = [File.join(ENV["HOME"], ".vagrant.d", "insecure_private_key")]

role :app, "kayak.test"
role :web, "kayak.test"
role :db,  "kayak.test", :primary => true

after "deploy:setup" do
  deploy.fast_git_setup.clone_repository
  run "cd #{current_path} && bundle install"
end

namespace :unicorn do
  desc "Start unicorn for this application"
  task :start do
    run "cd #{current_path} && bundle exec unicorn -c /etc/unicorn/kayak.conf.rb -D"
  end
end

namespace :deploy do
  task :create_symlink do; end
end
