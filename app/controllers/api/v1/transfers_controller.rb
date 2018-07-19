class Api::V1::TransfersController < ApplicationController
  skip_before_action :authenticate_request

  def create
    @name = params.require(:name)
    @transfer = Transfer.new({name: @name})

    if @transfer.save
      render status: 201, json: {"transfer" => @transfer.reload}
    else
      render status: 400, json: {"errors" => @transfer.errors}
    end
  end
end
