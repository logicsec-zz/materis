require File.expand_path('../boot', __FILE__)

require 'csv'
require 'rails/all'

Bundler.require(:default, Rails.env)

module Fluxday
  class Application < Rails::Application
    config.to_prepare do
      Doorkeeper::AuthorizationsController.layout "doorkeeper"
      Doorkeeper::AuthorizedApplicationsController.layout "doorkeeper"
    end
  end
end
