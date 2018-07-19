class Trip < ApplicationRecord
  has_many :tickets
  belongs_to :transfer

  after_create :create_tickets

  validates :departure_time, :arrival_time, :number_of_tickets, presence: true
  validate :start_date_before_end_date
  validates :number_of_tickets, numericality: {greater_than_or_equal_to: 0, only_integer: true}


  def start_date_before_end_date
    if self.departure_time > self.arrival_time
      errors.add(:departure_time, "Departure date and time should be before arrival date and time")
    end
  end

  private

  def create_tickets
    self.number_of_tickets.times do
      self.tickets.create(barcode: rand(10000..99999).to_s)
    end
  end
end
