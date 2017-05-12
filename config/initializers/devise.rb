OmniAuth.config.full_host = lambda do |env|
  scheme         = env['rack.url_scheme']
  local_host     = env['HTTP_HOST']
  forwarded_host = env['HTTP_X_FORWARDED_HOST']
  forwarded_host.blank? ? "#{scheme}://#{local_host}" : "#{scheme}://#{forwarded_host}"
end

Devise.setup do |config|
  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'
  require 'devise/orm/active_record'

  require "omniauth-fluxapp"
  config.omniauth :fluxapp, 'e4e68356c7fd3ece23ac24584705534037682362a8d0b138a6c8f9e58fff3c39', '194900c71a743625e7b6427719c62edd5e1764a6f9409e0321fefb253b47462f',{:provider_ignores_state => true}
  config.case_insensitive_keys = [ :email ]
  config.strip_whitespace_keys = [ :email ]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 10
  config.reconfirmable = true
  config.password_length = 8..128
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete
end
