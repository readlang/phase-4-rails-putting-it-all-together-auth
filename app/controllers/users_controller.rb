class UsersController < ApplicationController

    # signup - creates a user, creates the session cookie, return json
    def create
        user = User.create(user_params)
        if user.valid?
            session[:user_id] = user.id
            render json: user, status: :created
        else
            render json: {errors: user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    # checks if session cookie is present on return visit
    def show
        current_user = User.find_by( id: session[:user_id] )
        
        if current_user
            render json: current_user, status: :created
        else
            render json: { errors: ["Not authorized"] }, status: :unauthorized
        end
    end

    private

    def user_params
        params.permit( :username, :password, :password_confirmation, :image_url, :bio )
    end

end
