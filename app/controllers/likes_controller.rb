class LikesController < ApplicationController
	def create
		if(params[:like][:loveable_type] == 'Project')
			@project = Project.find(params[:like][:loveable_id])
			@project.likes.create(user_id: current_user.id)
			redirect_to projects_path
		end
	end

	def destroy
		Like.find(params[:id]).destroy
		redirect_to projects_path
	end
end
