class CreateMilestones < ActiveRecord::Migration
  def change
    create_table :milestones do |t|
      t.string :name
      t.datetime :start_date
      t.datetime :end_date
      t.references :job, index: true
    end
  end
end
