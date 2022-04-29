class RecipesController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
    
    before_action :authorize

    # returns all recipes
    def index
        recipes = Recipe.all
        render json: recipes, status: :created  # use serializer
    end

    # creates a new recipe
    def create
        user = User.find_by(id: session[:user_id])
        recipe = user.recipes.create!( params.permit( :title, :instructions, :minutes_to_complete ))
        # if recipe.valid?
        render json: recipe, status: :created
        # else
        #     render json: {errors: exception.record.errors.full_messages}, status: :unprocessable_entity
        # end
    end

    private

    def authorize
        render json: {errors: ["not authorized"]}, status: :unauthorized unless session.include? :user_id
    end

    def render_unprocessable_entity_response(exception)
        render json: {errors: exception.record.errors.full_messages}, status: :unprocessable_entity
    end

end
