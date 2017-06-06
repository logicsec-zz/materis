class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_filter :authenticate_user!
  after_filter :user_activity

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  private

  def user_activity
    current_user.try :touch
  end
end


