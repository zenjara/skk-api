class Api::V2::TicketsController < ApplicationController
  skip_before_action :authenticate_request
  before_action :authenticate_request_optional
  attr_reader :current_user

  def buy
    @name = @current_user ? @current_user.name : params.require(:name)
    @surname = @current_user ? @current_user.name : params.require(:surname)
    @email = @current_user ? @current_user.name : params.require(:email)
    @credit_card_number = params.require(:credit_card)

    validate_params
    return if performed?

    @trip = Trip.find(params[:id])

    if @trip
      if @trip.number_of_tickets > 0
        @ticket = Ticket.find_by trip: @trip, isPaid: false
        @payment = Payment.create(name: @name, surname: @surname, email: @email, ticket_id: @ticket.id)
        @ticket.update(user: @current_user) unless @current_user.nil?
        @ticket.update(isPaid: true)
        render status: 201, json: {"message" => "Ticket purchase successful!"}
      else
        render status: 400, json: {"message" => "No tickets available for this trip!"}
      end
    else
      render status: 400, json: {"message" => "No Trip associated with this ID!"}
    end
  end

  private

  def authenticate_request_optional
    @current_user = AuthorizeApiRequest.call(request.headers).result
  end

  def validate_params
    @param_errors = Hash.new()
    @param_errors[:credit_card] = ["Credit card number length invalid!"] unless @credit_card_number.length.between?(15, 16)

    render status: 400, json: @param_errors and return unless @param_errors.empty?
  end
end
