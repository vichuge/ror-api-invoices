class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler

  def authenticate_request!
    return invalid_authentication if !payload || !AuthenticationTokenService.valid_payload(payload.first)

    current_user!
    invalid_authentication unless @current_user
  end

  def authenticate_user!(invoice_id, user_id)
    @invoice = Invoice.find_by(id: invoice_id)
    return unless @invoice.user_id != user_id && @invoice.creator_id != user_id

    render json: { error: 'User not authorized' },
           status: :unauthorized
  end

  def current_user!
    @current_user = User.find_by(id: payload[0]['user_id'])
  end

  private

  def payload
    auth_header = request.headers['Authorization']
    token = auth_header.split.last
    AuthenticationTokenService.decode(token)
  rescue StandardError
    nil
  end

  def invalid_authentication
    render json: { error: 'You will need to login first' }, status: :unauthorized
  end
end
