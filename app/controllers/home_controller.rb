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

  def search
    @task = Task.searchable_for_user(current_user).find_by_tracker_id(params[:search][:keyword])
    if @task.present?
      redirect_to :controller=>'tasks',:action=>'show',:id=>@task.tracker_id
    else
      @tasks = Task.searchable_for_user(current_user).search('tracker_id_or_name_or_description_cont'=>params[:search][:keyword]).result.paginate(page: params[:page], per_page: 10).order('id DESC')
    end
  end
end
