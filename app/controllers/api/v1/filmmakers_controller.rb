module Api
  module V1
    class FilmmakersController < BaseController
      def list_film_makers
        @users=User.all.offset((params[:page].to_i-1)*10).limit(10)
        render :json=>@users , :each_serializer=>Api::V1::Serializers::FilmMakersSerializer, :meta => {pagination: {total_pages: (User.all.count.to_f/10).ceil, current_page: params[:page], total_count: User.all.count}}
      end
      def film_maker
        @user=User.find(params[:id])
        render :json=>@user , :serializer=>Api::V1::Serializers::FilmMakersSerializer, :root=>:film_maker
      end
    end
  end
end