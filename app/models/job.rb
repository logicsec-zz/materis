class Job < ActiveRecord::Base
  has_many :tasks, dependent: :destroy
  has_many :milestones, dependent: :destroy
  has_many :custom_fields
  belongs_to :user
  has_and_belongs_to_many :teams

  accepts_nested_attributes_for :custom_fields, reject_if: :all_blank, allow_destroy: true

  validates_presence_of :name, :code, :color, :team_ids
  validates_uniqueness_of :code

  mount_uploader :image, ImageUploader

  scope :active, -> {where(is_deleted: false)}
  scope :archived, -> {where(is_deleted: true)}

  def total_tasks
    return self.tasks.count
  end
  def completed_tasks
    return self.tasks.completed.count
  end
  def incomplete_tasks
    return self.tasks.pending.count
  end
  def project_status
    (self.tasks.count == 0) ? 0 : ((self.tasks.completed.count.to_f / self.tasks.count.to_f) * 100).to_i
  end
end