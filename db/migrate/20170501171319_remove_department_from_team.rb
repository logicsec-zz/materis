class RemoveDepartmentFromTeam < ActiveRecord::Migration
  def change
    remove_column :teams, :project_id
  end
end
