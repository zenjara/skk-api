class User < ApplicationRecord

  has_many :tickets
  has_many :payments
  has_secure_password

  validates :name, :surname, :email, presence: true
  validates :name, length: { minimum: 2 }
  validates :email, uniqueness: true
end
