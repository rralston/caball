class RoleApplicationsController < ApplicationController

  load_and_authorize_resource
  
  before_filter :search
  helper_method :mailbox, :conversation
  
  def new
    @role = Role.find(params[:role_id])
  end
  
  def create

    debugger
    role_application = current_user.role_applications.create(params[:role_application])

    project_owner = role_application.project.user
    
    # send message and email to the project owner
    message_body = "Role Application - #{role_application.role.name} (#{role_application.role.subrole})"
    conversation = current_user.
                    send_message(project_owner, role_application.message, message_body).
                      conversation

    # create a public activity addressed to the project owner
    role_application.create_activity action: 'create', recipient: project_owner, owner: current_user

    redirect_to project_path(role_application.project), :notice => 'Your application is submittied, Project owner will get back to you soon.'
  end

  def approve
    role_application = RoleApplication.find(params[:application_id])
    role = role_application.role
    if not role.filled
      role_application.update_attributes(:approved => true)  
      role.update_attributes(:filled => true)
      role.send_role_filled_messages

      render :json => role_application.to_json()
    else
      render :text => false
    end
  end

  def un_approve
    role_application = RoleApplication.find(params[:application_id])
    role = role_application.role
    role_application.update_attributes(:approved => false)  
    role.update_attributes(:filled => false)
    render :json => role_application.to_json()
  end

  def message_applicant
    role_application = RoleApplication.find(params[:application_id])
    message = params[:message]
    role = role_application.role
    applicant = role_application.user
    # send message and email to the project owner
    subject = "Reg. Role Application - #{role_application.role.name} (#{role_application.role.subrole})"

    current_user.send_message(applicant, message, subject)

  end

end