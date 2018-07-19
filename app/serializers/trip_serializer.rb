class TripSerializer < ActiveModel::Serializer
  attributes :id, :transfer_id, :departure_time, :arrival_time, :number_of_tickets
end