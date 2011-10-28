app_name = ask("What's the app name?")

run "rm public/index.html"
run "rm app/assets/stylesheets/application.css"
run "rm app/views/layouts/application.html.erb"
run "capify ."

# gems
gem "rack", :version => "1.3.3"
gem 'rake', :version => '>= 0.9.2.2'
gem "haml"
gem "haml-rails"
gem "compass", :group => :assets
gem 'execjs', :group => :production
gem 'therubyracer', :group => :production
gem 'capistrano'
gem 'autotest'
gem 'shoulda'
gem 'rspec', '~> 2.4'
gem 'rspec-rails', '~> 2.4'

#TODO add compass to config

# files
file 'app/assets/stylesheets/application.css.sass',
<<-CODE
//= require_self
//= require_tree .

@import "compass/reset"

body
  font-family: "Helvetica Neue", Helvetica, sans
  font-size: 1em
  line-height: 1.5em
  color: #222
CODE

file 'app/views/layouts/application.html.haml',
<<-CODE
!!!
%html
  %head
    %title #{app_name}
    = stylesheet_link_tag    "application"
    = javascript_include_tag "application"
    = csrf_meta_tags
  %body
    = yield
CODE

file 'config/deploy.rb',
<<-CODE
set :application, "#{app_name}"
set :scm, :git
set :repository,  "git@destroytoday.com:#{app_name}"
set :branch, "master"
set :deploy_via, :remote_cache
set :deploy_to, "/srv/www/#{app_name}.destroytoday.com"

set :user, "root"
set :use_sudo, true
set :ssh_options, { :forward_agent => true }

role :web, "#{app_name}.destroytoday.com"
role :app, "#{app_name}.destroytoday.com"
role :db,  "#{app_name}.destroytoday.com", :primary => true

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "\#{try_sudo} touch \#{File.join(current_path,'tmp','restart.txt')}"
  end
end
CODE

# git
git :init
git :add => "."
git :commit => "-am 'Initial commit'"

puts "Successfully created project using default template!"
