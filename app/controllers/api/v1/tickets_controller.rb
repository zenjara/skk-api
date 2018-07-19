class Api::V1::TicketsController < ApplicationController
  def buy
    @credit_card_number = params.require(:credit_card)
    @cvc = params.require(:cvc)

    validate_params
    return if performed?

    @trip = Trip.find_by_id(params[:id])

    if @trip
      if @trip.number_of_tickets > 0
        @ticket = Ticket.find_by trip: @trip, isPaid: false
        @payment = @current_user.payments.create(ticket_id: @ticket.id)
        @ticket.update(user: @current_user)
        @ticket.update(isPaid: true)

        render status: 201, json: {"message" => "Ticket purchase successful!"}
      else
        render status: 400, json: {"message" => "No tickets available for this trip!"}
      end
    else
      render status: 400, json: {"message" => "No Trip associated with this ID!"}
    end
  end

  def bought_tickets
    @tickets = Ticket.where(user: @current_user)
    render status: 200, json: @tickets
  end

  private

  def validate_params
    @param_errors = Hash.new()

    @param_errors[:credit_card] = ["Credit card number length invalid!"] unless @credit_card_number.length.between?(15, 16)
    @param_errors[:cvc] = ["CVC length invalid!"] unless @cvc.length == 4
    render status: 400, json: @param_errors and return unless @param_errors.empty?
  end
end
