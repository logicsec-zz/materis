class Project < ActiveRecord::Base
  has_many :teams, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :milestones, dependent: :destroy
  has_many :project_managers, dependent: :destroy
  has_many :users,:through=>:project_managers,:after_remove => :update_user_project_count
  has_many :team_members, :through => :teams, dependent: :destroy
  has_many :project_members, :through=>:team_members, :source=>:user, dependent: :destroy

  validates_presence_of :name, :code
  validates_uniqueness_of :code

  mount_uploader :image, ImageUploader

  default_scope{ order("projects.name ASC")}

  scope :active, -> {where(is_deleted: false)}
  scope :archived, -> {where(is_deleted: true)}

  def members
    return project_members.active.uniq
  end

  def update_user_project_count(pm)
    pm.update_attributes(:admin_projects_count=>pm.projects.count)
  end

  def update_numbers
    update_attributes(:team_count=>self.teams.count)
  end
  def total_tasks
    return self.tasks.count
  end
  def completed_tasks
    return self.tasks.completed.count
  end
  def incomplete_tasks
    return self.tasks.pending.count
  end
end
