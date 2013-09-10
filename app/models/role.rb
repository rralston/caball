class Role < ActiveRecord::Base
  belongs_to :project

  has_many :applications, :class_name => 'RoleApplication', :dependent => :destroy  

  accepts_nested_attributes_for :applications

  attr_accessible :name, :description, :filled, :subrole, :gender, :super_subrole, :applications_attributes

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

end