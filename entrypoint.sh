#!/bin/bash
set -e

# Remove server.pid if it exists
rm -f /app/tmp/pids/server.pid

# Check if this is a new project (no app directory exists)
if [ ! -d /app/app ]; then
  echo "Initializing new Rails project..."
  
  # Install Rails via bundler for rails new command
  RAILS_SETUP_DIR=/tmp/rails_setup
  mkdir -p $RAILS_SETUP_DIR
  cat > $RAILS_SETUP_DIR/Gemfile << 'RAILSSETUP'
source 'https://rubygems.org'
gem 'rails', '5.1.6'
gem 'nokogiri', '1.12.5'
gem 'ffi', '~> 1.15.5'
RAILSSETUP
  cd $RAILS_SETUP_DIR
  bundle install --quiet
  
  cd /tmp
  BUNDLE_GEMFILE=$RAILS_SETUP_DIR/Gemfile bundle exec rails new message_me --database=postgresql --skip-git --skip-bundle
  if [ -d message_me ]; then
    cd message_me
    # Move all files to /app, preserving existing files but merging directories
    find . -mindepth 1 -maxdepth 1 ! -name '.' ! -name '..' | while read item; do
      if [ -d "$item" ] && [ -d "/app/$item" ]; then
        # Directory exists, merge contents
        find "$item" -type f | while read file; do
          target="/app/$file"
          if [ ! -f "$target" ]; then
            mkdir -p "$(dirname "$target")"
            mv "$file" "$target" 2>/dev/null || true
          fi
        done
      else
        # File or new directory, move it
        [ ! -e "/app/$item" ] && mv "$item" /app/ 2>/dev/null || true
      fi
    done
  fi
  cd /app
  
  # Replace Gemfile to lock Rails 5.1.6
  cat > /app/Gemfile << 'EOF'
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.5.9'

gem 'rails', '5.1.6'
gem 'nokogiri', '1.12.5'
gem 'ffi', '~> 1.15.5'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'webpacker', '~> 3.0'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
EOF

  # Create database.yml
  mkdir -p /app/config
  cat > /app/config/database.yml << 'EOF'
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  host: db
  username: postgres
  password: postgres

development:
  <<: *default
  database: message_me_development

test:
  <<: *default
  database: message_me_test

production:
  <<: *default
  database: message_me_production
  username: postgres
  password: <%= ENV['DATABASE_PASSWORD'] %>
EOF

  # Create cable.yml
  cat > /app/config/cable.yml << 'EOF'
development:
  adapter: async

test:
  adapter: test

production:
  adapter: redis
  url: <%= ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" } %>
  channel_prefix: message_me_production
EOF

  # Create ActionCable initializer
  mkdir -p /app/config/initializers
  cat > /app/config/initializers/action_cable.rb << 'EOF'
Rails.application.config.action_cable.allowed_request_origins = [/http:\/\/localhost*/, /http:\/\/127\.0\.0\.1*/]
EOF

  # Install gems
  bundle install
  
  # Create database
  rails db:create
  
  # Run webpacker install (may fail if already installed, that's ok)
  rails webpacker:install || true
fi

# Install gems if Gemfile changed
bundle check || bundle install

# Install node modules if package.json exists and node_modules is empty
if [ -f /app/package.json ] && [ ! -d /app/node_modules ]; then
  yarn install
fi

# Execute the main command
exec "$@"
