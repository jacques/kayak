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

task :start do
  run "unicorn -c /etc/unicorn/kayak.conf.rb -D"
end

namespace :bundle do
  task :install do
    run "cd /u/apps/kayak/current && bundle install --gemfile /u/apps/kayak/current/Gemfile --path /u/apps/kayak/shared/bundle --deployment --without development test"
  end
end
