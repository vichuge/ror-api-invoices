require 'rails_helper'

RSpec.describe 'Invoices', type: :request do
  let!(:invoices) { create_list(:invoice, 5) }
  let!(:invoice) { invoices.first }
  let!(:invoice_id) { invoice.id }
  let!(:wrong_id) { 100_000_000 }
  let!(:user) { User.find_by(id: invoice.user_id) }

  # Test suite for GET api/v1/invoices
  describe 'GET api/v1/invoices' do
    context 'when there are no filters' do
      # make HTTP get request before each example
      before { get '/api/v1/invoices', headers: { 'Authorization' => AuthenticationTokenService.call(user.id) } }

      it 'returns status code 200' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when there are filters' do
      before {
        get "/api/v1/invoices?status=#{invoice.status}&emitter_name=#{invoice.emitter_name}
        &receiver_name=#{invoice.receiver_name}&amount_down=999&amount_up=100000001&issue_date=#{invoice.emitted_at}",
            headers: { 'Authorization' => AuthenticationTokenService.call(user.id) }
      }

      it 'returns invoices' do
        expect(json).not_to be_empty
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  # Test suite for POST api/v1/invoices
  describe 'POST api/v1/invoices' do
    let(:user_id) { invoices.last.id }
    let(:invoice_uuid) { FFaker::SSN.ssn }
    let(:status) { 'active' }
    let(:emitter_name) { FFaker::Name.name }
    let(:emitter_rfc) { FFaker::Bank.iban }
    let(:receiver_name) { FFaker::Name.name }
    let(:receiver_rfc) { FFaker::Bank.iban }
    let(:amount) { rand(1000..100_000_000) }
    let(:emitted_at) { FFaker::Time.date.to_s }
    let(:expires_at) { FFaker::Time.date.to_s }
    let(:signed_at) { FFaker::Time.date.to_s }
    let(:cfdi_digital_stamp) { FFaker::Bank.iban }
    let(:user_username) { user.username }
    let(:valid_invoice) {
      {
        invoice_uuid:,
        status:,
        emitter_name:,
        emitter_rfc:,
        receiver_name:,
        receiver_rfc:,
        amount:,
        emitted_at:,
        expires_at:,
        signed_at:,
        cfdi_digital_stamp:,
        user_username:
      }
    }
    let(:invalid_invoice) {
      {
        invoice_uuid: '',
        status: '',
        emitter_name: '',
        emiter_rfc: '',
        receiver_name: '',
        receiver_rfc: '',
        amount: '',
        emitted_at: '',
        expires_at: '',
        signed_at: '',
        cfdi_digital_stamp: '',
        user_username:
      }
    }

    context 'when the request is valid' do
      before do
        post '/api/v1/invoices',
             params: valid_invoice,
             headers: { 'Authorization' => AuthenticationTokenService.call(user.id) }
      end

      it 'creates an invoice' do
        expect(json['invoice_uuid']).not_to be_nil
        expect(json['status']).not_to be_empty
        expect(json['emitter_name']).not_to be_empty
        expect(json['emitter_rfc']).not_to be_empty
        expect(json['receiver_name']).not_to be_empty
        expect(json['receiver_rfc']).not_to be_empty
        expect(json['amount'].to_s).not_to be_empty
        expect(json['emitted_at']).not_to be_empty
        expect(json['expires_at']).not_to be_empty
        expect(json['signed_at']).not_to be_empty
        expect(json['cfdi_digital_stamp']).not_to be_empty
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(:created)
      end
    end

    context 'when the request is invalid' do
      before do
        post '/api/v1/invoices', params: invalid_invoice,
                                 headers: { 'Authorization' => AuthenticationTokenService.call(user.id) }
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to include("can't be blank")
      end
    end
  end

  # Test suite for GET api/v1/invoices/:id
  describe 'GET api/v1/invoices/:id' do
    context 'when the record exists' do
      before do
        get "/api/v1/invoices/#{invoice_id}", headers: { 'Authorization' => AuthenticationTokenService.call(user.id) }
      end

      it 'returns the invoice' do
        expect(json).not_to be_empty
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the record does not exist' do
      before do
        get '/api/v1/invoices/100', headers: { 'Authorization' => AuthenticationTokenService.call(user.id) }
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns a not found message' do
        expect(response.body).to include('Couldn\'t find Invoice')
      end
    end
  end

  # Test suite for PUT api/v1/invoices/:id
  describe 'PUT api/v1/invoices/:id' do
    context 'when the record exists' do
      before do
        put "/api/v1/invoices/#{invoice_id}", params: { status: 'paid' },
                                              headers: { 'Authorization' => AuthenticationTokenService.call(user.id) }
      end

      it 'updates the record' do
        expect(response.body).not_to include("Couldn't find Invoice with 'id'=#{invoice_id}")
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the record does not exist' do
      before do
        put "/api/v1/invoices/#{wrong_id}", params: { status: 'paid' },
                                            headers: { 'Authorization' => AuthenticationTokenService.call(user.id) }
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns a not found message' do
        expect(response.body).to include("Couldn't find Invoice with 'id'=#{wrong_id}")
      end
    end
  end

  # Test suite for DELETE api/v1/invoices/:id
  describe 'DELETE api/v1/invoices/:id' do
    let(:user_delete) { create(:user) }
    let(:invoice) { create(:invoice, user_id: user_delete.id) }
    let(:invoice_id) { invoice.id }

    context 'when the record exists' do
      before do
        delete "/api/v1/invoices/#{invoice_id}",
               headers: { 'Authorization' => AuthenticationTokenService.call(user.id) }
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when the record does not exist' do
      before do
        delete "/api/v1/invoices/#{wrong_id}", headers: { 'Authorization' => AuthenticationTokenService.call(user.id) }
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns a not found message' do
        expect(response.body).to include("Couldn't find Invoice with 'id'=#{wrong_id}")
      end
    end
  end

  describe 'get api/v1/invoices/qr/:id' do
    context 'when the record exists' do
      before do
        get "/api/v1/invoices/qr/#{invoice_id}",
            headers: { 'Authorization' => AuthenticationTokenService.call(user.id) }
      end

      it 'returns the invoice' do
        expect(json).not_to be_empty
        expect(json['qr_image']).to eq("https://chart.googleapis.com/chart?chs=200x200&cht=qr&chl=#{invoices.first.cfdi_digital_stamp}")
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the record does not exist' do
      before do
        get "/api/v1/invoices/qr/#{wrong_id}", headers: { 'Authorization' => AuthenticationTokenService.call(user.id) }
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns a not found message' do
        expect(response.body).to include("Couldn't find Invoice with 'id'=#{wrong_id}")
      end
    end
  end
end
