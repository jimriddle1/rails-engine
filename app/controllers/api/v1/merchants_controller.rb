class Api::V1::MerchantsController < ApplicationController

  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    # binding.pry
    if Merchant.where("id = #{params[:id]}").count == 0
      render status: 404
    else
      render json: MerchantSerializer.new(Merchant.find(params[:id]))
    end
  end

end
