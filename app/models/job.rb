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
  def time_to_end
    project_status = (self.tasks.count == 0) ? 0 : ((self.tasks.completed.count.to_f / self.tasks.count.to_f) * 100).to_i

    if end_date.to_date == Date.today
      'Due today'
    elsif end_date <= Date.today && project_status != 100
      'Past Due'
    elsif end_date <= Date.today && project_status == 100
      'Ended on '+end_date.strftime('%d %B %Y')
    elsif end_date <= 7.day.from_now
      rem = (end_date.to_date - Date.today.to_date).to_i
      "#{rem} #{'day'.pluralize(rem)} left"
    else
      'Due '+end_date.strftime('%d %B %Y')
    end
  end
end