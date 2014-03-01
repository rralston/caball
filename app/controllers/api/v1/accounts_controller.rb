module Api
  module V1
    class AccountsController < ActionController::Base
      protect_from_forgery with: :null_session
      skip_before_action :verify_authenticity_token, if: :json_request?

      def auth
        user, status_code = User.validate_user(params[:username], params[:password])
        render :json => user, :status => status_code
      end

      protected

      def json_request?
        request.format.json?
      end

     end
  end
end