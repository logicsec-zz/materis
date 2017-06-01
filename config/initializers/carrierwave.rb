CarrierWave.configure do |config|
  config.fog_provider = 'fog/google'                        # required
  config.fog_credentials = {
      provider:                         'Google',
      google_storage_access_key_id:     'GOOGCE4VW3SDOO7CB3NF',
      google_storage_secret_access_key: 'QKLCnu7m6vUSoAGlY6z4VE+9jy2w977Qr9DIX63v'
  }
  config.fog_directory = 'dauntless-flow-5911'
end