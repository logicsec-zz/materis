class MilestonesController < ApplicationController
  before_action :set_milestone, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  def index
    @milestones = Milestone.all
    @milestone = @milestones.first unless @milestones.empty?
  end

  def show
    @milestones = Milestone.all
  end

  def new
    @milestones = Milestone.all
    @jobs = Job.all
    @job= @jobs.first

    if params[:project_id].present?
      @job = Job.find(params[:project_id])
      @milestone.job_id = @job.id if @job.present?
    end
    @grouped_jobs = @jobs.inject({}) do |options, job|
      (options[job.name] ||= []) << [job.name, job.id]
      options
    end
  end

  def edit
    @milestones = Milestone.all

    @jobs = Job.all
    @job = Job.find(@milestone.job_id)
    @milestone.job_id = @job.id if @job.present?

    @grouped_jobs = @jobs.inject({}) do |options, job|
      (options[job.name] ||= []) << [job.name, job.id]
      options
    end
  end

  def create
    @milestone = Milestone.new(milestone_params)
    @job = Job.find milestone_params[:job_id]

    respond_to do |format|
      if @milestone.save
        format.html { redirect_to @job, notice: 'Milestone was successfully created.' }
        format.json { render action: 'show', status: :created, location: @milestone }
      else
        format.html { render action: 'new' }
        format.json { render json: @milestone.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @milestone = Milestone.find params[:id]
    @job = Job.find milestone_params[:job_id]

    respond_to do |format|
      if @milestone.update(milestone_params)
        format.html { redirect_to @job, notice: 'Milestone was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @milestone.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @milestone.destroy
    @job = Job.find @milestone.job.id

    respond_to do |format|
      format.html { redirect_to @job }
      format.json { head :no_content }
    end
  end

  private
  def set_milestone
    @milestone = Milestone.find(params[:id])
  end

  def milestone_params
    params.fetch(:milestone).permit(:name, :start_date, :end_date, :project_id, :job_id)
  end
end