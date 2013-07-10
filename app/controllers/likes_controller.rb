class LikesController < ApplicationController

	load_and_authorize_resource

	def create
		current_user.likes.create(loveable_id: params[:like][:loveable_id], loveable_type: params[:like][:loveable_type])
		respond_to do |format|
			format.js
		end
	end

	def destroy
		@like.destroy
		respond_to do |format|
			format.js
		end
	end
end
