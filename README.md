# Agimmo App

Apartments on a map with authentication, multi-photo uploads, and Leaflet-powered UI. Built with Rails 8, Importmap, Turbo, Stimulus, SQLite, and Active Storage.

## Stack

- Ruby on Rails 8 (Importmap, Turbo, Stimulus, Propshaft)
- SQLite (development/test)
- Active Storage (local Disk in development)
- Leaflet via CDN (OpenStreetMap tiles)
- Minitest (models and system tests)

## Setup

1. Requirements
   - Ruby 3.3+
   - Bundler
   - Node/Yarn not required (Importmap)
   - ImageMagick (recommended for variants; optional)

2. Install dependencies
   ```
   bundle install
   ```

3. Database setup
   ```
   bin/rails db:prepare
   bin/rails db:seed
   ```

4. Active Storage
   - Local Disk is used in development/test (default Rails config).
   - If the standard installer fails, the app includes a corrected migration for Active Storage tables.

5. Run server
   ```
   bin/rails s
   ```
   Open http://localhost:3000

## Features

- Authentication (sign up/in/out) using has_secure_password
- Apartments CRUD with owner authorization
- Full-width map view with a togglable list panel
- Bounding-box JSON endpoint for efficient marker loading
- Apartment show with mini-map and photo gallery
- Multi-photo uploads via Active Storage
- i18n: English (default) and Polish, with locale switch in the header

## Internationalization

- Default locale is English.
- Available locales: en, pl.
- Switch locale via the header links EN / PL.
- Locale is persisted in URLs through default_url_options.

## Tests

We use Minitest for model, controller, and system tests.

Run the full suite:
```bash
bin/rails test
```

System tests use the rack_test driver by default.

### Active Storage in tests

Active Storage is configured to use the local :test disk service in [`config/environments/test.rb`](config/environments/test.rb). Ensure the test database has the Active Storage tables.

If you see errors like “Could not find table 'active_storage_attachments'” or “Missing Active Storage service name”:

1) Ensure the service is set for test:
- ruby.configure() (config/environments/test.rb)
```ruby
# Use local disk for Active Storage in test to avoid external dependencies
config.active_storage.service = :test
```

2) Migrate and prepare the databases and schema:
```bash
bin/rails db:migrate
bin/rails db:schema:dump
bin/rails db:test:prepare   # if unavailable, use: RAILS_ENV=test bin/rails db:schema:load
```

3) Re-run tests:
```bash
bin/rails test
```

You should see all tests green, e.g., “18 runs, 40 assertions, 0 failures, 0 errors, 0 skips”.

### Troubleshooting

- Missing Active Storage tables in test:
  - Run `bin/rails db:schema:dump` and then `bin/rails db:test:prepare` (or `RAILS_ENV=test bin/rails db:schema:load`) to load Active Storage tables into the test DB.
- Service not configured for test:
  - Confirm `config.active_storage.service = :test` is present in the test environment configuration.

Included:
- test/models/user_test.rb
- test/models/apartment_test.rb
- test/system/auth_flow_test.rb
- test/system/apartments_flow_test.rb

System tests assume Capybara system driver is configured (Rails defaults). If running in headless mode, ensure the driver is available.

## Leaflet and Tiles

- Leaflet CSS/JS is included via CDNs in the main layout.
- Tiles: OpenStreetMap via https://{s}.tile.openstreetmap.org
- Attribution is kept visible with a small CSS z-index boost.

## Production Notes

- Database: use PostgreSQL or MySQL in production.
- Active Storage: configure S3 or compatible object storage.
  - Set credentials and service config in config/storage.yml and credentials.
  - Precompile assets and run migrations on deploy.

## Known/Optional Improvements

- Generate thumbnails with variants and add a lightbox on the show page.
- Status enum UI: filter draft/published in index based on ownership.
- Add clustering or spiderfy for dense marker areas.
- More comprehensive translations and error messages.

## License

MIT
