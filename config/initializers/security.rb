# Additional security configurations

Rails.application.configure do
  # Rate limiting (basic implementation - consider using rack-attack gem for production)
  config.middleware.use Rack::Attack if Rails.env.production?
  
  # Security headers
  config.force_ssl = true if Rails.env.production?
  
  # Additional security headers
  config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins Rails.env.production? ? ENV['ALLOWED_ORIGINS']&.split(',') || [] : '*'
      resource '*',
               headers: :any,
               methods: [:get, :post, :put, :patch, :delete, :options, :head],
               credentials: true
    end
  end if defined?(Rack::Cors)
end

# Configure Rack::Attack if available
if defined?(Rack::Attack) && Rails.env.production?
  # Throttle requests by IP
  Rack::Attack.throttle('requests by ip', limit: 300, period: 5.minutes) do |request|
    request.ip
  end

  # Throttle login attempts by IP address
  Rack::Attack.throttle('logins/ip', limit: 5, period: 20.seconds) do |request|
    if request.path == '/sign_in' && request.post?
      request.ip
    end
  end

  # Throttle login attempts by email address
  Rack::Attack.throttle("logins/email", limit: 5, period: 20.seconds) do |request|
    if request.path == '/sign_in' && request.post?
      request.params.dig('session', 'email').presence
    end
  end
end