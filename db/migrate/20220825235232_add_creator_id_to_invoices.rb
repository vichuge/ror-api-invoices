class AddCreatorIdToInvoices < ActiveRecord::Migration[6.1]
  def change
    add_column :invoices, :creator_id, :integer
  end
end
