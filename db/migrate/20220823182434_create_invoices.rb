class CreateInvoices < ActiveRecord::Migration[6.1]
  def change
    create_table :invoices do |t|
      t.string :invoice_uuid
      t.string :status
      t.string :emitter_name
      t.string :emitter_rfc
      t.string :receiver_name
      t.string :receiver_rfc
      t.integer :amount
      t.datetime :emitted_at
      t.datetime :expires_at
      t.datetime :signed_at
      t.string :cfdi_digital_stamp

      t.timestamps
    end
  end
end
