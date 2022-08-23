require 'rails_helper'

RSpec.describe Invoice, type: :model do
  it { is_expected.to validate_presence_of(:invoice_uuid) }
  it { is_expected.to validate_presence_of(:status) }
  it { is_expected.to validate_presence_of(:emitter_name) }
  it { is_expected.to validate_presence_of(:emitter_rfc) }
  it { is_expected.to validate_presence_of(:receiver_name) }
  it { is_expected.to validate_presence_of(:receiver_rfc) }
  it { is_expected.to validate_presence_of(:amount) }
  it { is_expected.to validate_presence_of(:emitted_at) }
  it { is_expected.to validate_presence_of(:expires_at) }
  it { is_expected.to validate_presence_of(:signed_at) }
  it { is_expected.to validate_presence_of(:cfdi_digital_stamp) }
end
