class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :archive]
  load_and_authorize_resource

  def index
    @projects = Project.active
    @project = @projects.first unless @projects.empty?

    @archived_projects = Project.archived
    @archived_project = @archived_projects.first unless @projects.empty?
  end

  def show
    @projects = Project.active
    @teams = @project.teams
    @managers = @project.users.by_name
    @members = @project.members.where('').map{|x| x}.sort{|a,b| a.name<=>b.name}
  end

  def add_members
    @teams = Team.for_user(current_user)
    @team = Team.find(params[:team_id])
    @users = User.active.by_name
    @members = @team.members.by_name
  end

  def new
    @projects = Project.active
    @project = Project.new
    @users= User.active
  end

  def edit
    @projects = Project.active
    @users= User.active
  end

  def create
    @project = Project.new(project_params)
    @users= User.active

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render action: 'show', status: :created, location: @project }
      else
        format.html { render action: 'new' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @users= User.active
    @project = Project.find params[:id]
    if params[:project][:is_deleted]
      @project.update_attribute(:is_deleted, params[:project][:is_deleted])
      @project.teams.update_all(:is_deleted => params[:project][:is_deleted])
      @project.tasks.update_all(:is_deleted => params[:project][:is_deleted])
    end
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end

  def get_member_list
    team = Team.find(params[:team_id])
    if (current_user.admin_teams.include?(team) || current_user.project_ids.include?(team.project_id))
      @users = team.members.by_name
    else
      @users = team.team_leads.by_name
    end
    start_date = params[:start_date].to_date
    end_date = params[:end_date].to_date
    @kr_ids = Task.find(params[:task_id]).key_result_ids unless params[:task_id].blank?
    @kr_ids ||= []
    @key_results = team.key_results.where('key_results.start_date <= ? && key_results.end_date >= ?', end_date, start_date).group_by(&:user_id)
  end

  private
  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit!
  end
end
