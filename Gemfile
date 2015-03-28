source 'https://rubygems.org'
ruby '2.1.5'

gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg'
gem 'bootstrap_form'
gem 'bcrypt'
gem 'fabrication'
gem 'faker'
gem 'sidekiq'
gem 'unicorn'
gem 'sentry-raven'
gem 'paratrooper'
gem 'carrierwave'
gem 'fog'
gem 'fog-aws'
gem 'mini_magick'
gem 'figaro'
gem 'stripe'
gem 'draper', '~> 1.3'

group :development do
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'letter_opener'
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '2.99'
end

group :test do
  gem 'database_cleaner', '1.2.0'
  gem 'shoulda-matchers', require: false
  gem 'capybara'
  gem 'launchy'
  gem 'capybara-email'
  gem 'vcr'
  gem 'webmock'
  gem 'selenium-webdriver'
end

group :production, :staging do
  gem 'rails_12factor'
end
