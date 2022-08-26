namespace :invoice do
  desc 'Upload invoices on xml format to database'
  task upload_invoices: [:environment] do
    files = Dir['public/20220811012132-invoices/**/*.xml']
    files.each do |file|
      invoice_xml = File.read(file)
      invoice_hash = Hash.from_xml(invoice_xml)
      user = FactoryBot.create(:user)
      invoice = user.invoices.new
      invoice.invoice_uuid = invoice_hash['hash']['invoice_uuid']
      invoice.status = invoice_hash['hash']['status']
      invoice.emitter_name = invoice_hash['hash']['emitter']['name']
      invoice.emitter_rfc = invoice_hash['hash']['emitter']['rfc']
      invoice.receiver_name = invoice_hash['hash']['receiver']['name']
      invoice.receiver_rfc = invoice_hash['hash']['receiver']['rfc']
      invoice.amount = invoice_hash['hash']['amount']['cents']
      invoice.emitted_at = invoice_hash['hash']['emitted_at']
      invoice.expires_at = invoice_hash['hash']['expires_at']
      invoice.signed_at = invoice_hash['hash']['signed_at']
      invoice.cfdi_digital_stamp = invoice_hash['hash']['cfdi_digital_stamp']
      invoice.creator_id = user.id
      invoice.save
    end
  end
end
