class Setting < ActiveRecord::Base
  has_one :ccl

  validates_presence_of :title
  validates_presence_of :number_of_writing

  validates_numericality_of :number_of_writing, greater_than_or_equal_to: 1, less_than_or_equal_to: 20

  validates :author_email, format: { with: /([a-z0-9.-_]+@[a-z0-9-_]+(.[a-z0-9-_]+)+|)/i, message: "is not email." }

  before_validation :default_values

  before_save :be_inactive_existing_active_setting_if_necessary

  scope :with_ccl, -> { joins("LEFT OUTER JOIN ccls ON ccls.id = settings.ccl_id").select("settings.*, ccls.name as ccl_name, ccls.url as ccl_url") }
  scope :active, -> { where(active: true) }

  def default_values
    self.active = Setting.active.empty? || !active.nil?
    self.title ||= "Blog"
    self.number_of_writing ||= 5
  end

  def be_inactive_existing_active_setting_if_necessary
    if active
      existing_active_settings = Setting.active.where.not(id: id)

      unless existing_active_settings.empty?
        existing_active_settings.each do |existing_active_setting|
          existing_active_setting.update_column(:active, false)
        end
      end
    end
  end

  def self.active_setting
    Setting.with_ccl.active.first || Setting.create!
  end

  def be_active
    update(active: true)
  end
end
