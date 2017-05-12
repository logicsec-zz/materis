class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :name
      t.string :code
      t.text :description
      t.boolean :is_deleted
      t.integer :team_count
      t.string :image
      t.string :color

      t.timestamps
    end
  end
end
