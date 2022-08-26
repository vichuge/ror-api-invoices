class InvoiceRepresenter
  def initialize(invoice)
    @invoice = invoice
  end

  def as_json
    {
      id: invoice.id,
      invoice_uuid: invoice.invoice_uuid,
      status: invoice.status,
      emitter_name: invoice.emitter_name,
      emitter_rfc: invoice.emitter_rfc,
      receiver_name: invoice.receiver_name,
      receiver_rfc: invoice.receiver_rfc,
      amount: "$#{(invoice.amount * 0.01).round(2)}",
      emitted_at: invoice.emitted_at,
      expires_at: invoice.expires_at,
      signed_at: invoice.signed_at,
      cfdi_digital_stamp: invoice.cfdi_digital_stamp,
      qr_image: "https://chart.googleapis.com/chart?chs=200x200&cht=qr&chl=#{@invoice.cfdi_digital_stamp}",
      user_id: User.find_by(id: invoice.user_id).username,
      creator: User.find_by(id: invoice.creator_id).username
    }
  end

  private

  attr_reader :invoice
end
