module Api
  module V1
    class FilmmakersController < BaseController

      def list_film_makers
        puts "///////////////////"
        @users=User.all
        render :json=>@users , :each_serializer=>Api::V1::Serializers::FilmMakerSerializer
      end

    end
  end
end