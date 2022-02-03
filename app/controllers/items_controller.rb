class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

  # GET /users/:user_id/items
  def index
    if params[:user_id]
      # need to refactor
      user = User.find(params[:user_id])
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  # GET /users/:user_id/items/:id
  def show
    item = Item.find(params[:id])
    render json: item
  end

  #  POST /users/:user_id/items
  def create
    # need to refactor
    user = User.find(params[:user_id])
    item = user.items.create!(item_params)
    render json: item, status: :created
  end


  private

  def item_params
    params.permit(:name, :description, :price)
  end

  def render_not_found_response(invalid)
    render json: { errors: "Request not found" }, status: :not_found
  end

  def render_unprocessable_entity_response(invalid)
    render json: { errors: invalid.record.errors }, status: :unprocessable_entity
  end

end
