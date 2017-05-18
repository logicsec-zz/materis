class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  load_and_authorize_resource
  #load_and_authorize_resource :task, :through => [:team,:task], :shallow => true

  # GET /tasks
  # GET /tasks.json
  def index
    #@tasks = current_user.assignments
    @tasks = current_user.watching_tasks.pending.paginate(page: params[:page], per_page: 10)
    @fin_tasks = current_user.watching_tasks.completed.paginate(page: params[:page], per_page: 10) unless params[:page]
  end

  def completed_index
    #@tasks = current_user.assignments
    @fin_tasks = current_user.watching_tasks.completed.paginate(page: params[:page], per_page: 10)
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @tasks = current_user.assigned_and_written_tasks.pending.paginate(page: params[:page], per_page: 10)
    @fin_tasks = current_user.watching_tasks.completed.paginate(page: params[:page], per_page: 10) unless params[:page]
    @team = @task.team
    @project = @team.project
    @sub_tasks = @task.sub_tasks
    @comment = @task.comments.new
  end

# GET /tasks/new
  def new
    @root_task = Task.find(params[:task_id]) if params[:task_id].present?
    @team = @root_task.team if params[:task_id].present?
    @jobs = Job.all
    @task = @root_task.present? ? @root_task.sub_tasks.new : Task.new
    @task.start_date = Time.now
    @task.end_date = Time.now
    if params[:team_id].present?
      @team = Team.find(params[:team_id])
      @task.team_id = @team.id if @team.present?
      @task.project_id = @team.project_id if @team.present?
    end

    if params[:project_id].present?
      @job = Job.find(params[:project_id])
      @milestone = @job.milestones.first
      @task.job_id = @job.id if @job.present?
      @milestones = @job.milestones
      @milestone = Milestone.find(params[:milestone_id])
      @teams = @job.teams
    end

    @grouped_milestones = @milestones.inject({}) do |options, milestone|
      (options[milestone.name] ||= []) << [milestone.name, milestone.id]
      options
    end
    @grouped_teams = @teams.inject({}) do |options, team|
      (options[team.project.name] ||= []) << [team.name, team.id]
      options
    end
    @grouped_jobs = @jobs.inject({}) do |options, job|
      (options[job.name] ||= []) << [job.name, job.id]
      options
    end
    @team ||= @teams.first
    if @team.present?
    if (current_user.admin_teams.include?(@team) || current_user.project_ids.include?(@team.project_id))
      @users = @team.members
    else
      @users = @team.team_leads
    end
    else
      redirect_to root_path, :alert => 'You have no access to a team in order to assign a task.'
    end
  end

  # GET /tasks/1/edit
  def edit
    @projects = Project.active

    @jobs = Job.all
    @task.job_id = @job.id if @job.present?
    @job = Job.find(@task.job_id)
    @milestone = @task.milestone
    @milestones = @job.milestones

    @team ||= @task.team
    @teams = Team.assignable_by_user(current_user).includes(:project)

    @grouped_teams = @teams.inject({}) do |options, team|
      (options[team.project.name] ||= []) << [team.name, team.id]
      options
    end
    @grouped_milestones = @milestones.inject({}) do |options, milestone|
      (options[milestone.name] ||= []) << [milestone.name, milestone.id]
      options
    end
    @grouped_jobs = @jobs.inject({}) do |options, job|
      (options[job.name] ||= []) << [job.name, job.id]
      options
    end

    @users = @team.try(&:members)
    start_date = @task.start_date
    end_date = @task.end_date
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)
    @task.project_id = @task.team.project_id if @task.team.present?
    if task_params[:job_id].present?
      @job = Job.find(task_params[:job_id])
    end

    respond_to do |format|
      if @task.save
        format.html { redirect_to @job, notice: 'Task was successfully created.' }
        format.json { render action: 'show', status: :created, location: @task }
      else
        format.html { render action: 'new' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    @job = Job.find(@task.job_id)
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @job, notice: 'Task was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    respond_to do |format|
      format.html { redirect_to jobs_url }
      format.json { head :no_content }
    end
  end

  def completion
    @task = Task.find(params[:id])
    if request.post?
      @task.update_attributes(:completed_on => params[:task][:completed_on].to_time, :status => 'completed') if (params[:task] && params[:task][:completed_on])
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def task_params
    params.require(:task).permit(:name, :description, :start_date, :task_id, :end_date, :project_id, :team_id, :user_id, :job_id, :milestone_id, :tracker_id, :priority, :comments_count, :status, :completed_on, :key_result_ids => [], :user_ids => [])
  end
end
