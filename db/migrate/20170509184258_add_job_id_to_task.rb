class AddJobIdToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :job_id, :integer
  end
end
