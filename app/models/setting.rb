class Setting < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :number_of_writing

  validates_numericality_of :number_of_writing, greater_than_or_equal_to: 1, less_than_or_equal_to: 20

  before_validation :default_values

  before_save :be_inactive_existing_active_setting_if_necessary

  scope :active, -> { where(active: true) }

  def default_values
    self.active = Setting.active.empty? || !active.nil?
    self.title ||= "Blog"
    self.number_of_writing ||= 5
  end

  def be_inactive_existing_active_setting_if_necessary
    if active
      existing_active_setting = Setting.active.where.not(id: id).first

      unless existing_active_setting.nil?
        existing_active_setting.update(active: false)
      end
    end
  end

  def self.active_setting
    Setting.active.first || Setting.create!
  end

  def be_active
    update(active: true)
  end
end
