class UserMailer < ActionMailer::Base
  default from: "\"filmmo Notifications\" <notifications@filmzu.com>"

  def signup_confirmation(user)
    @user = user
    mail to: user.email, subject: "Sign Up Confirmation"
  end

  def report_entity_mail(reporting_user, entity, message)
    @entity = entity
    @reporting_user = reporting_user
    @message = message
    # send email to the admin users.
    mail to: User.admin_emails, subject: "Reporting wrong #{@entity.class.name}"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.signup_confirmation.subject
  #
end
