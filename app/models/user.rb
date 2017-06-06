class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :employee_code

  mount_uploader :image, ImageUploader

  has_many :project_managers, dependent: :destroy
  has_many :projects, :through => :project_managers
  has_many :team_members, dependent: :destroy
  has_many :teams, :through => :team_members
  has_many :admin_teams, :through => :projects, :source => :teams
  has_many :leads, -> { where role: 'lead' }, class_name: 'TeamMember'
  has_many :admin_teams, :through => :leads, :source => :team #,:foreign_key=>'user_id'
  has_many :joined_projects, :through => :teams, :source => :project
  has_many :comments
  has_many :reporting_managers, dependent: :destroy
  has_many :jobs
  has_many :tasks
  has_many :managers, :through => :reporting_managers, :class_name => 'User'
  has_many :reporting_employees, :class_name => "ReportingManager", :foreign_key => "manager_id", dependent: :destroy
  has_many :users, :through => :reporting_employees, :class_name => 'User', :foreign_key => "user_id"
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :lastseenable, :omniauthable, :omniauth_providers => [:google_oauth2, :fluxapp]
  scope :active, -> { where(is_deleted: false) }
  scope :by_name, -> { order("users.name ASC") }
  scope :manager_user, -> {where("role in (?)",["admin","Manager"])}

  validates_presence_of :name, :nickname
  validate :email, :presence => true, :uniqueness => true
  validate :employee_code, :presence => true, :uniqueness => true

  before_update :ensure_manager_exists

  def admin?
    role.downcase == 'admin'
  end

  def manager?
    role.downcase.in?(['manager', 'admin'])
  end

  def employee?
    role.downcase == 'employee'
  end

  def accessible_users
    unless manager?
      project_user_ids = projects.collect(&:project_member_ids).flatten
      team_member_ids = admin_teams.collect(&:user_ids).flatten
      managing_users = user_ids
      user_ids = [id]
      user_ids = user_ids + project_user_ids + team_member_ids +user_ids
      user_ids = user_ids.uniq
      users = User.where(id: user_ids).by_name
    else
      users= User.by_name
    end
  end

  def assigned_and_written_tasks
    Task.where(id: (task_ids).uniq)
  end

  def watching_tasks
    Task.active.where("id IN (?) OR team_id IN (?)", (task_ids).uniq, admin_team_ids)
  end

  def log_viewable_tasks
    if manager?
      Task.active
    else
      Task.active.where("id IN (?) OR team_id IN (?)", (task_ids + assignment_ids).uniq, admin_team_ids)
    end
  end

  def ensure_manager_exists
      if User.manager_user.count == 1 and self.changes.present? and self.changes[:role].present?
          if self.changes[:role][0] == "admin" and self.changes[:role][1] == "Manager"
            self.role = "admin"
            return true
          elsif (self.changes[:role][0] == "admin" and self.changes[:role][1] == "Employee" ) or (self.changes[:role][0] == "Manager" and self.changes[:role][1] == "Employee")
            errors[:base] << "Atleast one manager required"
            return false
          else
            return true
          end
      end
  end

  def online?
    updated_at > 10.minutes.ago
  end

  def seen_at
    if self.online?
      '<span class="tag tag-members">Online</span>'
    else
      '<span class="tag tag-managers">Offline</span>'
    end
  end
end