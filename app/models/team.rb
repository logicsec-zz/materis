class Team < ActiveRecord::Base
  mount_uploader :image, ImageUploader

  belongs_to :project
  has_many :team_members, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :users, :through => :team_members
  has_many :okrs, :through => :users
  has_many :key_results, :through => :okrs
  has_many :leads, -> { where role: 'lead' }, class_name: 'TeamMember', dependent: :destroy
  has_many :team_leads, :through => :leads, :source => :user, dependent: :destroy
  has_many :members, -> { uniq }, :through => :team_members, :source => :user, dependent: :destroy

  validates_presence_of :name, :code, :project_id

  # default_scope { where.not(is_deleted: true).order("teams.name ASC") }

  scope :active, -> { where(status: 'active') }
  scope :archived, -> { where(is_deleted: true) }
  scope :unarchived, -> { where(is_deleted: false) }
  scope :available, -> do
    if project.is_deleted?
      where(Team.archived)
    else
      where(Team.unarchived)
    end
  end

  after_save :update_project_team_count
  after_destroy :update_project_team_count


  def update_project_team_count
    project.update_attributes(:team_count => project.teams.active.count)
    project.update_attributes(:team_count => project.teams.active.count)
  end

  def self.for_user(user)
    teams = Team.where("project_id IN (?) OR id IN (?)",user.project_ids,(user.admin_team_ids + user.team_ids).uniq)
  end

  def self.admind_by_user(user)
    teams = Team.where("project_id IN (?) OR id IN (?)",user.project_ids,user.admin_team_ids.uniq)
  end

  def self.assignable_by_user(user)
    teams = Team.where(project_id:(user.project_ids+user.admin_teams.collect(&:project_id).uniq))
  end

  def total_tasks
    return self.tasks.count
  end
end
