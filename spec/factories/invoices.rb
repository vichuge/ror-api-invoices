FactoryBot.define do
  factory :invoice do
    user { create(:user) }
    invoice_uuid { FFaker::SSN.ssn }
    status { 'active' }
    emitter_name { FFaker::Name.name }
    emitter_rfc { FFaker::Bank.iban }
    receiver_name { FFaker::Name.name }
    receiver_rfc { FFaker::Bank.iban }
    amount { rand(1000..100_000_000) }
    emitted_at { FFaker::Time.date.to_s }
    expires_at { FFaker::Time.date.to_s }
    signed_at { FFaker::Time.date.to_s }
    cfdi_digital_stamp { FFaker::Bank.iban }
    creator_id { user.id }
  end
end
