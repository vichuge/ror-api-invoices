class InvoicesRepresenter
  def initialize(invoices)
    @invoices = invoices
  end

  def as_json
    invoices.map do |invoice|
      {
        id: invoice.id,
        invoice_uuid: invoice.invoice_uuid,
        status: invoice.status,
        emitter_name: invoice.emitter_name,
        emitter_rfc: invoice.emitter_rfc,
        receiver_name: invoice.receiver_name,
        receiver_rfc: invoice.receiver_rfc,
        amount: invoice.amount,
        emitted_at: invoice.emitted_at,
        expires_at: invoice.expires_at,
        signed_at: invoice.signed_at,
        cfdi_digital_stamp: invoice.cfdi_digital_stamp
      }
    end
  end

  private

  attr_reader :invoices
end
