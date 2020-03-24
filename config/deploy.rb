require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'
# require 'mina_sidekiq/tasks'
require 'mina/unicorn'

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

# set :domain, 'foobar.com'
# set :deploy_to, '/var/www/foobar.com'
# set :repository, 'git://github.com/vinsol/Crowdfunding.git'
# set :branch, 'master'
set :term_mode, nil

set :domain, '52.26.166.181' #aws: 52.26.166.181, linode: 45.79.158.198
set :deploy_to, '/var/www/html/chewcandy/'
set :repository, 'git@bitbucket.org:uditm/chewcandy.git'
set :branch, 'master'
set :user, 'ubuntu' #aws: ubuntu ,linode: chewcandy
set :forward_agent, true
set :port, '22'
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"

# For system-wide RVM install.
#   set :rvm_path, '/usr/local/rvm/bin/rvm'

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/database.yml', 'config/secrets.yml', 'log/production.log', 'config/newrelic.yml', 'public/system']

# set_default :asset_paths, %w(app/assets/javascripts/dashboard_js/dashboard.js app/assets/stylesheets/dashboard_css/dashboard.css, app/assets/javascripts/*.js, app/assets/stylesheets/dashboard_css/signin.css, app/assets/stylesheets/dashboard_css/styles.css)

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  queue %{
  echo "-----> Loading environment"
  #{echo_cmd %[source ~/.bashrc]}
  }
  invoke :'rbenv:load'
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .rbenv-version to your repository.
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[mkdir -p "#{deploy_to}/shared/public"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/public"]

  queue! %[mkdir -p "#{deploy_to}/shared/public/system"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/public/system"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue  %[echo "-----> Be sure to edit 'shared/config/database.yml'."]

  queue! %[touch "#{deploy_to}/shared/config/secrets.yml"]
  queue %[echo "-----> Be sure to edit 'shared/config/secrets.yml'."]

  queue! %[touch "#{deploy_to}/shared/config/newrelic.yml"]
  queue %[echo "-----> Be sure to edit 'shared/config/newrelic.yml'."]

  queue! %[touch "#{deploy_to}/shared/log/production.log"]

  # sidekiq needs a place to store its pid file and log file
  queue! %[mkdir -p "#{deploy_to}/shared/pids/"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/pids"]

  queue! %[mkdir -p "#{deploy_to}/shared/sockets/"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/sockets"]
end

namespace :deploy do
  desc "Symlinks upload directory for paerclip."
  task :symlink_directories do
    queue! "ln -nfs #{deploy_to}/shared/public/system #{deploy_to}/current/public/system"
  end
end

# This loads all env variables
task :env_variables_load do
  queue! "echo '-----> Loading environment variables'"
  queue! "source ~/.bashrc"
  queue! "source ~/.profile"
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  # This loads all env variables
  invoke :env_variables_load

  deploy do

    # stop accepting new workers
    # invoke :'sidekiq:quiet'
    # queue! "cp -rf #{deploy_to}/current/public/system #{deploy_to}/shared/public"
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile:force'
    invoke :'deploy:symlink_directories'

    to :launch do
      invoke :'unicorn:restart'
    end
  end
end

# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers

