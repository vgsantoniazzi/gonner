source 'https://rubygems.org'

gem 'rails', '~> 5.0.0'
gem 'pg'
gem 'puma'
gem 'kaminari'

group :production, :staging do
  gem 'rails_12factor'
  gem 'newrelic_rpm'
end

group :development, :test do
  gem 'byebug'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'rubocop'
end

group :development do
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'better_errors'
end

group :test do
  gem 'shoulda-matchers'
  gem 'simplecov'
  gem 'database_cleaner'
end

