class LikesController < ApplicationController
	def create
		current_user.likes.create(loveable_id: params[:like][:loveable_id], loveable_type: params[:like][:loveable_type])
		respond_to do |format|
			format.js
		end
	end

	def destroy
		Like.find(params[:id]).destroy
		respond_to do |format|
			format.js
		end
	end
end
