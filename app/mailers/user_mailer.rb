class UserMailer < ActionMailer::Base
  default from: "\"Filmzu Notifications\" <notification@filmzu.com>"

  def signup_confirmation(user)
    @user = user
    mail to: user.email, subject: "Sign Up Confirmation"
  end

  def report_entity_mail(reporting_user, entity)
    @entity = entity
    @reporting_user = reporting_user
    mail to: 'vishnu@devbrother.com', subject: "Reporting wrong #{@entity.class.name}"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.signup_confirmation.subject
  #
end
