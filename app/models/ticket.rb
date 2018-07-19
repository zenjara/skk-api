class Ticket < ApplicationRecord
  belongs_to :user, optional: true
  has_one :payment
  belongs_to :trip

  validates :barcode, presence: true
end
