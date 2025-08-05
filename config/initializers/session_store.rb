# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :cookie_store, 
  key: '_agimmo_app_session',
  expire_after: 24.hours,
  secure: Rails.env.production?,
  httponly: true,
  same_site: :lax

# Configure session security
Rails.application.configure do
  # Rotate session on sign in/out
  config.force_ssl = true if Rails.env.production?
  
  # Session timeout and rotation
  config.session_options = {
    expire_after: 24.hours,
    secure: Rails.env.production?,
    httponly: true,
    same_site: :lax
  }
end