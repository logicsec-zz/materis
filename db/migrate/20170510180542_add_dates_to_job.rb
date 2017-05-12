class AddDatesToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :start_date, :datetime
    add_column :jobs, :end_date, :datetime
  end
end
