class EndorsementsController < ApplicationController

  load_and_authorize_resource

  def create
    @endorsement = Endorsement.create(params[:endorsement])
    
    @endorsement.create_activity action: 'create', recipient: @endorsement.receiver, owner: current_user

    render 'users/endorsement_create'
  end

end