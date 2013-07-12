class EndorsementsController < ApplicationController

  load_and_authorize_resource

  def create
    @endorsement = Endorsement.create(params[:endorsement])

    render 'users/endorsement_create'
  end

end