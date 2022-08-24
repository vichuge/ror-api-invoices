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

  scope :index_filters, lambda { |params|
    hash = {}
    params_filter = params.except(:amount_down, :amount_up, :issue_date)
    params_filter.each do |key, value|
      next if value.blank?

      hash[key] = value
    end
    hash[:emitted_at] = params[:issue_date] if params[:issue_date].present?
    if params[:amount_down].present? && params[:amount_up].present?
      hash[:amount] = params[:amount_down]..params[:amount_up]
    end

    where(hash).order('created_at')
  }
end
