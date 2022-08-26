module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_request!, only: :index

      def index
        users = User.all.order(:id)
        render json: UsersRepresenter.new(users).as_json, status: :ok
      end

      def create
        user = User.create(user_params)
        if user.save
          render json: UserRepresenter.new(user).as_json, status: :created
        else
          render json: { error: user.errors.full_messages.first }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:username, :password)
      end
    end
  end
end
