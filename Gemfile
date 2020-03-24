source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.8'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring', '~>1.3.6',        group: :development

gem 'thin', '~> 1.6.2'
gem 'paperclip', '~> 4.2.1'
gem 'devise', '~> 4.7.1'
gem 'acts_as_shopping_cart', '~> 0.2.1'

gem 'ckeditor'

# For soft delete
gem 'paranoia'

# For decorators
gem 'draper'

# For blog
gem 'acts-as-taggable-on', '~> 3.4'
gem 'acts_as_commentable_with_threading'

# For Multiple Table Inheritance
gem 'active_record-acts_as'

#For State Machine
gem 'aasm'

# For Pagination
gem 'kaminari'

# For slugs / peralinks
gem 'friendly_id', '~> 5.1.0'

# Heroku: udit7590@yahoo.com
gem 'rails_12factor', group: :staging
gem 'non-stupid-digest-assets', '1.0.4', group: :production

group :development do
  gem 'letter_opener',                '~> 1.2.0'
  gem 'quiet_assets',                 '~> 1.0.2'
end

group :development, :test do
  gem 'byebug'
end

group :test do
  gem 'shoulda-matchers',             '~> 2.8.0'
  gem 'factory_girl_rails',           '~> 4.4.1'
  gem 'rspec-rails',                  '~> 3.1.0'
end
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

# Payment
# gem 'stripe', git: 'https://github.com/stripe/stripe-ruby'
gem 'razorpay'

# For Deployment
gem 'unicorn'
gem 'mina'
gem 'mina-sidekiq', require: false
gem 'mina-unicorn', require: false

# For scheduling
gem 'daemons'
gem 'delayed_job_active_record'

# For debugging optimization
gem 'rack-mini-profiler', group: [:development, :test]

# gem 'whenever', require: false

# For PDF
gem 'prawn', '~> 1.3.0'
gem 'prawn-table', '~> 0.2.1'

# New Relic
gem 'newrelic_rpm', group: :production