class ProjectMember < ActiveRecord::Base
  belongs_to :team
  belongs_to :job

  default_scope {where.not(status:'archived')}
end