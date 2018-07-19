class TicketSerializer < ActiveModel::Serializer
  attributes :id, :barcode
  belongs_to :trip

  class TripSerializer < ActiveModel::Serializer
    attributes :arrival_time, :departure_time
  end
end

