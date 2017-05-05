class AddProjectsTeamsTable < ActiveRecord::Migration
  def change
    create_table :projects_teams do |t|
      t.belongs_to :project
      t.belongs_to :team
    end
    add_index :projects_teams, [:project_id, :team_id], unique: true
  end
end
