class LikesController < ApplicationController
	def create
		session[:back] = request.referer
		current_user.likes.create(loveable_id: params[:like][:loveable_id], loveable_type: params[:like][:loveable_type])
		redirect_to session[:back]
	end

	def destroy
		session[:back] = request.referer
		Like.find(params[:id]).destroy
		redirect_to session[:back]
	end
end
