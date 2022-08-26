class Invoice < ApplicationRecord
  belongs_to :user

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
  validates :creator_id, presence: true

  scope :index_filters, lambda { |params, id|
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

    where(hash).where(['creator_id = :id or user_id = :id', { id: }]).order('created_at')
  }

  scope :element_invoice, lambda { |params, id|
    @user = User.find_by(username: params[:user_username])
    @invoice = @user.invoices.new
    @invoice.invoice_uuid = params[:invoice_uuid]
    @invoice.status = params[:status]
    @invoice.emitter_name = params[:emitter_name].titleize
    @invoice.emitter_rfc = params[:emitter_rfc]
    @invoice.receiver_name = params[:receiver_name].titleize
    @invoice.receiver_rfc = params[:receiver_rfc]
    @invoice.amount = params[:amount]
    @invoice.emitted_at = params[:emitted_at]
    @invoice.expires_at = params[:expires_at]
    @invoice.signed_at = params[:signed_at]
    @invoice.cfdi_digital_stamp = params[:cfdi_digital_stamp]
    @invoice.creator_id = id
    @invoice
  }
end
