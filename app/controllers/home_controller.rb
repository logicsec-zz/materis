class HomeController < ApplicationController
  def index
    if current_user.present?
      dashboard
      render 'home/dashboard'
    else

    end
  end

  def dashboard
    @jobs = Job.all
  end
end
