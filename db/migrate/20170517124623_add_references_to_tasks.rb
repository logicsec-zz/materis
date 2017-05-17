class AddReferencesToTasks < ActiveRecord::Migration
  def change
    add_reference :tasks, :milestone, index: true
  end
end
