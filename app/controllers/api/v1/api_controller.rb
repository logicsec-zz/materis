module Api::V1
  class ApiController < ApplicationController

    def current_resource_owner
      user = OauthApplication.find(doorkeeper_token.try(&:application_id)).users.where(id:doorkeeper_token.try(&:resource_owner_id)).first
    end

  end
end


