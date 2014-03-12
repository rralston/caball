module Api
  module V1
    class FilmMakersController < BaseController
      def list_film_makers
        @users=User.all
        render :json=>@users , :each_serializer=>Api::V1::Serializers::FilmMakerSerializer
      end

    end
  end
end