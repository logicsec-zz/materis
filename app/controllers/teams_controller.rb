class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource :project
  load_and_authorize_resource :team, :through => :project, :shallow => true

  # GET /teams
  # GET /teams.json
  def index
    @projects = Project.active
    if params[:project_id].present?
      @project = Project.find(params[:project_id])
      @teams = @project.teams.active
    else
      @teams = Team.for_user(current_user)
    end
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
    @teams = Team.for_user(current_user)
    @team_leads = @team.team_leads
    @members = @team.members.by_name
  end

  def add_members
    @teams = Team.for_user(current_user)
    @team = Team.find(params[:team_id])
    @users = User.active.by_name
    @members = @team.members.by_name
  end

  # GET /teams/new
  def new
    if current_user.manager?
      @projects = Project.active
    else
      @projects = current_user.projects.active
    end
    @users = User.active
    if params[:project_id].present?
      @project = Project.find(params[:project_id])
      @team = @project.teams.new
    else
      @team = Team.new
    end
  end

  # GET /teams/1/edit
  def edit
    @users = User.active
    @projects = Project.active
  end

  # POST /teams
  # POST /teams.json
  def create
    @users = User.active
    @team = Team.new(team_params)
    @projects = Project.active
    respond_to do |format|
      if @team.save
        format.html { redirect_to @team, notice: 'Team was successfully created.' }
        format.json { render action: 'show', status: :created, location: @team }
      else
        format.html { render action: 'new' }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    @users = User.active
    @projects = Project.active

    respond_to do |format|
      if @team.update(team_params)
        @team.update_attributes(:members_count=>@team.users.active.count)
        @team.update_attributes(:managers_count=>@team.team_leads.active.count)
        @team.project.update_attributes(:member_count=>@team.project.project_members.active.count)

        format.html { redirect_to @team, notice: 'Team was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url }
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
  def set_team
    @team = Team.find(params[:id])
  end

  def team_params
    params.fetch(:team).permit(:name, :code, :description, :project_id, :members_count, :managers_count, :is_deleted, :pending_tasks, :status, :color, :image, :team_lead_ids => [], :user_ids => [])
  end
end
