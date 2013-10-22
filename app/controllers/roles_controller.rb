class RolesController < ApplicationController

  load_and_authorize_resource
  
  def applicants_list
    role = Role.find(params[:role_id])
    applications = role.applications
    render :json => applications.to_json(:include => [:user, :role => { :include => :project }])
  end

  def destroy
    role = Role.find(params[:id])
    role.destroy
    render :json => true
  end
  
end