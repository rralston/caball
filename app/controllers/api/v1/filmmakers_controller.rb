module Api
  module V1
    class FilmmakersController < BaseController
      def list_film_makers
        @users=User.all.offset((params[:page].to_i-1)*10).limit(10)
        render :json=>@users , :each_serializer=>Api::V1::Serializers::FilmMakerSerializer, :meta => {pagination: {total_pages: (User.all.count.to_f/10).ceil, current_page: params[:page], total_count: User.all.count}}
      end
    end
  end
end