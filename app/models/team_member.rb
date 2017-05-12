class TeamMember < ActiveRecord::Base
  belongs_to :team
  belongs_to :user

  default_scope {where.not(status:'archived')}

  after_save :update_member_counts

  def update_member_counts
    user.update_attributes(:admin_teams_count=>user.admin_teams.count) if self.role == 'lead'
    team.update_attributes(:members_count=>team.users.active.count)
    team.update_attributes(:managers_count=>team.team_leads.active.count)
  end
end