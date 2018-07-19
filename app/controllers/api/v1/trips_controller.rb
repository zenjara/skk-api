class Api::V1::TripsController < ApplicationController
  skip_before_action :authenticate_request

  def create
    validate_params
    return if performed?

    @transfer = Transfer.find(params[:id])
    @trip = @transfer.trips.new(trip_params)
    if @trip.save
      render status: 201, json: @trip
    else
      render status: 400, json: {"errors" => @trip.errors}
    end
  end

  private

  def trip_params
    params.permit(:departure_time, :arrival_time, :number_of_tickets)
  end

  def validate_params
    @param_errors = Hash.new()

    @param_errors[:departure_time] = [" is missing!"] unless params[:departure_time]
    @param_errors[:arrival_time] = [" is missing!"] unless params[:arrival_time]
    @param_errors[:number_of_tickets] = [" is missing!"] unless params[:number_of_tickets]
    render status: 400, json: @param_errors and return unless @param_errors.empty?
  end
end
