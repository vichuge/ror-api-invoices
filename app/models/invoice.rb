class Invoice < ApplicationRecord
  validates :invoice_uuid, presence: true
  validates :status, presence: true
  validates :emitter_name, presence: true
  validates :emitter_rfc, presence: true
  validates :receiver_name, presence: true
  validates :receiver_rfc, presence: true
  validates :amount, presence: true
  validates :emitted_at, presence: true
  validates :expires_at, presence: true
  validates :signed_at, presence: true
  validates :cfdi_digital_stamp, presence: true
end
