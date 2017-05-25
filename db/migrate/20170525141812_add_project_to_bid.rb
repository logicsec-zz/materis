class AddProjectToBid < ActiveRecord::Migration
  def change
    add_column :bids, :project_id, :integer
  end
end
