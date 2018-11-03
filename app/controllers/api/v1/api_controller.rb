module Api
  module V1
    class ApiController < ActionController::API
      include JSONAPI::ActsAsResourceController
      include Knock::Authenticable
      include Pundit

      before_action :authenticate_user
      before_action :set_paper_trail_whodunnit

      undef_method :current_user

      def context
        {
          current_user:         current_user,
          current_organization: current_organization
        }
      end

      def current_user
        current_compendico_user
      end

      def current_organization
        @current_organization ||=
          Compendico::Organization.find_by! api_key: request.headers['x-api-key']
      end

    private

      def authenticate_user
        authenticate_for Compendico::User
      end
    end
  end
end
