require 'rails_helper'

RSpec.describe 'Invoices', type: :request do
  let!(:invoices) { create_list(:invoice, 5) }
  let!(:invoice_id) { invoices.first.id }

  # Test suite for GET /invoice
  describe 'GET /invoices' do
    # make HTTP get request before each example
    before { get '/api/v1/invoices' }

    it 'returns invoices' do
      expect(json).not_to be_empty
      expect(json.size).to eq(5)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:ok)
    end
  end

  # Test suite for POST /invoice
  describe 'POST /invoice' do
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
        cfdi_digital_stamp:
      }
    }

    context 'when the request is valid' do
      before { post '/api/v1/invoices', params: valid_invoice }

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
      before {
        post '/api/v1/invoices', params:
        {
          invoice_uuid: '',
          status: '',
          emitter_name: '',
          emmiter_rfc: '',
          receiver_name: '',
          receiver_rfc: '',
          amount: '',
          emitted_at: '',
          expires_at: '',
          signed_at: '',
          cfdi_digital_stamp: ''
        }
      }

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to include("can't be blank")
      end
    end
  end
end
