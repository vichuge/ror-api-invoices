module Api
  module V1
    class InvoicesController < ApplicationController
      before_action :set_invoice, only: %i[destroy update show show_qr]

      # GET /invoices
      def index
        if (filter_params[:amount_down].present? && filter_params[:amount_up].blank?) ||
           (filter_params[:amount_down].blank? && filter_params[:amount_up].present?)
          render json: { error: 'User needs to use amount up and down together' },
                 status: :unprocessable_entity
        else
          @invoices = Invoice.index_filters(filter_params)
          render json: InvoicesRepresenter.new(@invoices).as_json
        end
      end

      # POST /invoice
      def create
        @invoice = Invoice.create(invoice_params)
        @invoice.emitter_name = @invoice.emitter_name.titleize
        @invoice.receiver_name = @invoice.receiver_name.titleize
        if @invoice.save
          render json: InvoiceRepresenter.new(@invoice).as_json, status: :created
        else
          render json: @invoice.errors, status: :unprocessable_entity
        end
      end

      def show
        render json: InvoiceRepresenter.new(@invoice).as_json
      end

      def show_qr
        url = "https://chart.googleapis.com/chart?chs=200x200&cht=qr&chl=#{@invoice.cfdi_digital_stamp}"
        render json: { qr_image: url }.as_json
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

      def filter_params
        params.permit(:status, :emitter_name, :emitter_rfc, :receiver_name, :receiver_rfc, :amount_down, :amount_up,
                      :issue_date)
      end

      def set_invoice
        @invoice = Invoice.find(params[:id])
      end
    end
  end
end
