class Api::V1::MerchantsController < ApplicationController

  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    if params[:id].to_i == 0
      render status: 404
    elsif Merchant.where("id = #{params[:id]}").count == 0
      render status: 404
    else
      render json: MerchantSerializer.new(Merchant.find(params[:id]))
    end
  end

end



# def show
#   render json: MerchantSerializer.new(Merchant.find(params[:id]))
# end
