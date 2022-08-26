module Api
  module V1
    class InvoicesController < ApplicationController
      before_action :authenticate_request!
      before_action :set_invoice, only: %i[destroy update show show_qr]
      before_action :authenticate_user, only: %i[destroy update show show_qr]

      # GET /invoices
      def index
        if (filter_params[:amount_down].present? && filter_params[:amount_up].blank?) ||
           (filter_params[:amount_down].blank? && filter_params[:amount_up].present?)
          render json: { error: 'User needs to use amount up and down together' },
                 status: :unprocessable_entity
        else
          @invoices = Invoice.index_filters(filter_params, current_user!.id)
          render json: InvoicesRepresenter.new(@invoices).as_json, status: :ok
        end
      end

      # POST /invoice
      def create
        if User.find_by(username: params[:user_username]).nil?
          render json: { error: 'User not found' }, status: :unprocessable_entity
        else
          @invoice = Invoice.element_invoice(invoice_params, current_user!.id)
          if @invoice.save
            render json: InvoiceRepresenter.new(@invoice).as_json, status: :created
          else
            render json: @invoice.errors, status: :unprocessable_entity
          end
        end
      end

      # GET /invoices/:id
      def show
        render json: InvoiceRepresenter.new(@invoice).as_json
      end

      # GET /invoices/:id/qr
      def show_qr
        url = "https://chart.googleapis.com/chart?chs=200x200&cht=qr&chl=#{@invoice.cfdi_digital_stamp}"
        render json: { qr_image: url }.as_json
      end

      # PUT /invoices/:id
      def update
        if @invoice.update(invoice_update_params)
          render json: InvoiceRepresenter.new(@invoice).as_json, status: :ok
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
                      :emitted_at, :expires_at, :signed_at, :cfdi_digital_stamp, :user_username)
      end

      def invoice_update_params
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

      def authenticate_user
        authenticate_user!(params[:id], current_user!.id)
      end
    end
  end
end
