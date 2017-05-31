class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  def index
    @jobs = Job.all
    @job = @jobs.first unless @jobs.empty?
  end

  def show
    @jobs = Job.all
    @teams = @job.teams
  end

  def new
    @jobs = Job.all
    @team = Team.new
    @teams = Team.active
  end

  def edit
    @jobs = Job.all
    @teams = Team.active
  end

  def create
    @job = Job.new(job_params)
    @teams = Team.active
    @job.user_id = current_user.id
    respond_to do |format|
      if @job.save
        format.html { redirect_to @job, notice: 'Job was successfully created.' }
        format.json { render action: 'show', status: :created, location: @job }
      else
        format.html { render action: 'new' }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @teams = Team.active
    @job = Job.find params[:id]
    respond_to do |format|
      if @job.update(job_params)
        format.html { redirect_to @job, notice: 'Job was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @job.destroy
    respond_to do |format|
      format.html { redirect_to jobs_url }
      format.json { head :no_content }
    end
  end

  private
  def set_job
    @job = Job.find(params[:id])
  end

  def job_params
    params.fetch(:job).permit(:name, :code, :description, :is_deleted, :color, :image, :start_date, :end_date, :team_ids => [], custom_fields_attributes: [:id, :name, :value, :_destroy])
  end
end
