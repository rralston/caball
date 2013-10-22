class LikesController < ApplicationController

	load_and_authorize_resource

	def create

		like = current_user.likes.where(:loveable_id => params[:like][:loveable_id], :loveable_type => params[:like][:loveable_type]).first
		
		# multiple clicks might lead to create multiple likes. this will prevent it.
		if like.nil?
			like = current_user.likes.create(loveable_id: params[:like][:loveable_id], loveable_type: params[:like][:loveable_type])
		end

		respond_to do |format|
			format.js
			format.json { render :json => like.loveable.to_json(:check_user => current_user) }
		end
	end

	def destroy
		@like.destroy
		respond_to do |format|
			format.js
		end
	end

	def unlike
		like = current_user.likes.where(loveable_id: params[:like][:loveable_id], loveable_type: params[:like][:loveable_type]).first
		like.destroy
		respond_to do |format|
			format.json { render :json => like.loveable.to_json(:check_user => current_user) }
		end
	end
end
