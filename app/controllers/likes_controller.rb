class LikesController < ApplicationController

	load_and_authorize_resource

	def create
		@like = current_user.likes.create(loveable_id: params[:like][:loveable_id], loveable_type: params[:like][:loveable_type])
		respond_to do |format|
			format.js
			format.json { render :json => @like.loveable.to_json(:check_user => current_user) }
		end
	end

	def destroy
		@like.destroy
		respond_to do |format|
			format.js
		end
	end

	def unlike
		@like = current_user.likes.where(loveable_id: params[:like][:loveable_id], loveable_type: params[:like][:loveable_type]).first
		@like.destroy
		respond_to do |format|
			format.json { render :json => @like.loveable.to_json(:check_user => current_user) }
		end
	end
end
