Materis::Application.configure do
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.action_mailer.raise_delivery_errors = false
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.log_level = :debug
  config.assets.debug = false
  config.action_controller.permit_all_parameters = true
  config.action_mailer.default_url_options = { host: 'localhost:3000' }

  config.to_prepare do
    Devise::SessionsController.layout "login"
  end

end
