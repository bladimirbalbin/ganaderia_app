source "https://rubygems.org"

ruby "3.3.7"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.5", ">= 7.1.5.1"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mswin mingw x64_mingw jruby ]


# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
# Autenticación
gem 'devise'

# Autorización y roles
gem 'pundit'

# Control de planes, auditoría, etc.
gem 'paper_trail'       # Auditar cambios
gem 'acts_as_tenant'    # Multi-tenant por cliente
gem 'sidekiq', '~> 7.2'           # Background jobs
gem 'dotenv-rails'      # Variables de entorno locales

# Desarrollo
gem 'pry-rails'         # Consola más potente
gem 'annotate'          # Anotar modelos con schema
gem 'rspec-rails', group: [:development, :test] # Testing
gem 'factory_bot_rails', group: [:development, :test]
gem 'faker', group: [:development, :test]

# Documentación de API si decides exponerla
gem 'rswag'            # Swagger

# PDF y exportaciones
gem 'prawn'
gem 'caxlsx_rails'

gem 'ransack'      # búsqueda
gem 'kaminari'     # paginación
gem 'kaminari-i18n' # Internacionalización para Kaminari
end

