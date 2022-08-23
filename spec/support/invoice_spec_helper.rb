module InvoiceSpecHelper
  def json
    JSON.parse(response.body)
  end
end
