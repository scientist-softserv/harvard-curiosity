source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.5'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

# Brings in Harvard assets
gem 'harvard-patterns-gem', '1.1', git: 'https://gitlab.com/harvard-library-web-team/harvard-patterns-gem.git', tag: '1.1'

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'listen', '~> 3.3'
  gem 'rack-mini-profiler', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'database_cleaner-active_record'
  gem 'rspec_junit_formatter'
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'blacklight', ' ~> 7.0'
gem 'blacklight-spotlight', github: 'projectblacklight/spotlight'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'debug'
  gem 'factory_bot_rails'
  gem 'rspec-rails'
  gem 'solr_wrapper', '>= 0.3'
end
gem 'blacklight-gallery', '~> 3.0'
gem 'blacklight-oembed', '~> 1.0'
gem 'bootstrap', '~> 4.0'
gem 'coffee-rails', '~> 4.2'
gem 'devise'
gem 'devise-guests', '~> 0.8'
gem 'devise_invitable'
gem 'friendly_id'
gem 'jquery-rails'
gem 'openseadragon', '>= 0.2.0'
gem 'pg', '~> 1.2'
gem 'redis'
gem 'rsolr', '>= 1.0', '< 3'
gem 'sitemap_generator'
gem 'twitter-typeahead-rails', '0.11.1.pre.corejavascript'
gem 'uglifier', '>= 1.3.0'

# gems for linting
gem 'pronto'
gem 'pronto-rubocop', require: false
gem 'rubocop', require: false
gem 'rubocop-rails', require: false
gem 'rubocop-rspec', require: false

# Sentry-raven for error handling
gem 'sentry-raven'

gem 'delayed_job_active_record'
