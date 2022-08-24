module Api
  module V1
    class InvoicesController < ApplicationController
      before_action :set_invoice, only: %i[destroy update show]
      # GET /invoices
      def index
        @invoices = Invoice.all
        render json: InvoicesRepresenter.new(@invoices).as_json
      end

      # POST /invoice
      def create
        @invoice = Invoice.create(invoice_params)
        if @invoice.save
          render json: InvoiceRepresenter.new(@invoice).as_json, status: :created
        else
          render json: @invoice.errors, status: :unprocessable_entity
        end
      end

      def show
        render json: @invoice.as_json
      end

      # PUT /invoices/:id
      def update
        if @invoice.update(invoice_params)
          render json: InvoiceRepresenter.new(@invoice).as_json
        else
          render json: @invoice.errors, status: :unprocessable_entity
        end
      end

      # DELETE /invoices/:id
      def destroy
        @invoice.destroy
        head :no_content
      end

      private

      def invoice_params
        params.permit(:invoice_uuid, :status, :emitter_name, :emitter_rfc, :receiver_name, :receiver_rfc, :amount,
                      :emitted_at, :expires_at, :signed_at, :cfdi_digital_stamp)
      end

      def set_invoice
        @invoice = Invoice.find(params[:id])
      end
    end
  end
end
