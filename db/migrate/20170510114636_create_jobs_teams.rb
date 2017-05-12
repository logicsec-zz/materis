class CreateJobsTeams < ActiveRecord::Migration
  def change
    create_table :jobs_teams do |t|
      t.integer :job_id
      t.integer :team_id
    end
  end
end
