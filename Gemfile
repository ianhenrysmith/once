source 'https://rubygems.org'

ruby '1.9.3'
gem 'rails', '3.2.13.rc2' # IS: upgrade this before release b/c rails exploit

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  gem 'uglifier', '>= 1.0.3'
  gem 'haml_coffee_assets'
  gem 'execjs'
end

# Deploy with Capistrano
# gem 'capistrano'

gem 'debugger'

# frontend
gem "haml", ">= 3.0.0"
gem "haml-rails"
gem "jquery-rails"
gem "rails-backbone"

#backend
gem "bson_ext"
gem "mongoid", ">= 2.0.0.beta.19"
gem 'delayed_job_mongoid'
gem "iron_worker_ng"

gem 'memcachier'
gem 'dalli'

gem "devise"
gem "cancan", ">= 1.5.0"

gem "httparty"
gem 'unicorn'

#uploads
gem 'carrierwave-mongoid', :git => 'git://github.com/jnicklas/carrierwave-mongoid.git'
gem "mini_magick"
gem "fog"
gem "aws-s3",            :require => "aws/s3" #do I need this one?
gem "aws-sdk"
gem 'rack-raw-upload'
gem 'jack_up', git: "git://github.com/thoughtbot/jack_up.git", branch: "use_form_data"

gem "sanitize"

# testing
gem "jasmine"