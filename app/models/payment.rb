class Payment < ApplicationRecord
  belongs_to :user, optional: true
  after_create :decrease_number_of_tickets_for_a_trip

  private

  def decrease_number_of_tickets_for_a_trip
    @ticket = Ticket.find(self.ticket_id)
    @trip = Trip.find(@ticket.trip_id)

    @trip.update(number_of_tickets: (@trip.number_of_tickets - 1))
  end
end
