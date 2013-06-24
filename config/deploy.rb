#$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"
require "bundler/capistrano"

set :application, "D3"
set :repository,  "git@github.com:Chrisell/D3.git"

set :rvm_type, :system
set :rvm_ruby_string, '2.0.0-p0'

set :scm, :git
set :branch, "master"
set :deploy_via, :remote_cache
set :deploy_to, "/home/chris/apps/#{application}"

set :user, "chris"
set :use_sudo, false
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "ellbot.com"                          # Your HTTP server, Apache/etc
role :app, "ellbot.com"                          # This may be the same as your `Web` server
role :db,  "ellbot.com", :primary => true # This is where Rails migrations will run

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
