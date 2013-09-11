class Role < ActiveRecord::Base
  belongs_to :project

  has_many :applications, :class_name => 'RoleApplication', :dependent => :destroy  

  accepts_nested_attributes_for :applications

  attr_accessible :name, :description, :filled, :subrole, :gender, :super_subrole, :applications_attributes,
                  :age, :ethnicity, :height, :build, :haircolor, :cast_title

  before_save :reset_cast_role_options

  def reset_cast_role_options
    # if role is not cast. Reset these optional fields to nil
    if self.name != 'Cast'
      self.age        = nil
      self.ethnicity  = nil
      self.height     = nil
      self.build      = nil
      self.haircolor  = nil
      self.cast_title = nil
    end
  end

  def serializable_hash(options)
    hash = super(options)
    extra_hash = {
      'project' => project,
      'approved_user' => approved_user
    }
    hash.merge!(extra_hash)
  end

  def send_application_rejection_mails
    self.project.user.
          send_message(rejected_users, "Sorry that Your application is not accepted for the #{self.name} (#{self.subrole}) role in project #{self.project.title}", "Regarding Role Application - Sorry").
            conversation
  end

  def send_application_approval_mail
    self.project.user.
          send_message(approved_user, "Your application is accepted for the #{self.name} (#{self.subrole}) role in project #{self.project.title}", "Congratulations").
            conversation
  end

  def send_role_filled_messages
    self.send_application_approval_mail
    self.send_application_rejection_mails
  end

  def rejected_users
    self.applications.select{ |application|
      !application.approved
    }.map(&:user)
  end

  def approved_user
    self.applications.select{ |application|
      application.approved
    }.map(&:user).first
  end

  def reset_optional_fields
    update_attributes(:subrole => nil, :super_subrole => nil)
  end

end