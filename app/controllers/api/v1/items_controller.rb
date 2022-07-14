class Api::V1::ItemsController < ApplicationController

  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    if Item.where("id = #{params[:id]}").count == 0
      render status: 404
    else
      render json: ItemSerializer.new(Item.find(params[:id]))
    end
  end

  def create
    render json: ItemSerializer.new(Item.create(item_params)), status: :created
  end

  def destroy
    item = Item.find(params[:id])
    item.delete_item_invoices

    render json: Item.delete(params[:id])
  end

  def update
    item = Item.update(params[:id], item_params)
    if item.save
      render json: ItemSerializer.new(item)
    else
      render status: 404
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end

end
