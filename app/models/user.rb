class User < ApplicationRecord
  has_secure_password
  has_many :invoices, dependent: :destroy
  validates :username, presence: true, uniqueness: true, length: { minimum: 1 }
  validates :password, presence: true, length: { minimum: 5 }
end
