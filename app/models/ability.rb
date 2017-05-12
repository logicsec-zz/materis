class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    alias_action :new, :edit, :create, :read, :update, :destroy, :to => :crud
    alias_action :new, :edit, :create, :read, :update, :to => :cru

    if user.admin?
      can :manage, :all
    elsif user.manager?
      can :manage, :all
    elsif user.employee?
      can [:edit,:update], Project, :id => user.project_ids
      can :index, Team
      can :index, Job
      can :manage, Team, :leads => {:user_id=>user.id}
      can [:edit,:update], User, :id=>[user.id]+user.user_ids

      can :read, Project
      can :read, Team
      can :read, Job

      can :destroy, Okr do |okr|
        user.user_ids.include?(okr.user_id)
      end

      can :cru, Okr , :user => { :id => ([user.id] + user.user_ids)   }, :approved=>false

      can :change_password, User
      can :read, Okr do |okr|
        okr.user_id == user.id || user.user_ids.include?(okr.user_id)
      end
      can :read, User
      can :manage, Task do |task|
        task.id.nil? || task.user_id == user.id || user.project_ids.include?(task.project_id) || user.admin_team_ids.include?(task.team_id)
      end

      can :read, Task do |task|
        task.id.nil? || task.user_id == user.id || task.user_ids.include?(user.id) || user.project_ids.include?(task.project_id) || user.team_ids.include?(task.team_id)
      end
    else
      #can :read, :all
    end
  end
end
