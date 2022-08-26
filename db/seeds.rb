# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create(username: 'admin_username', password: '123456')
user2 = User.create(username: FFaker::Internet.user_name, password: FFaker::Internet.password)
User.create(username: FFaker::Internet.user_name, password: FFaker::Internet.password)
User.create(username: FFaker::Internet.user_name, password: FFaker::Internet.password)
User.create(username: FFaker::Internet.user_name, password: FFaker::Internet.password)
User.create(username: FFaker::Internet.user_name, password: FFaker::Internet.password)
User.create(username: FFaker::Internet.user_name, password: FFaker::Internet.password)

Invoice.create(
  user_id: User.last.id,
  invoice_uuid: FFaker::SSN.ssn,
  status: 'active',
  emitter_name: FFaker::Name.name,
  emitter_rfc: FFaker::Bank.iban,
  receiver_name: FFaker::Name.name,
  receiver_rfc: FFaker::Bank.iban,
  amount: rand(1000..100_000_000),
  emitted_at: FFaker::Time.date.to_s,
  expires_at: FFaker::Time.date.to_s,
  signed_at: FFaker::Time.date.to_s,
  cfdi_digital_stamp: FFaker::Bank.iban,
  creator_id: User.first.id
)
Invoice.create(
  user_id: User.last.id,
  invoice_uuid: FFaker::SSN.ssn,
  status: 'active',
  emitter_name: FFaker::Name.name,
  emitter_rfc: FFaker::Bank.iban,
  receiver_name: FFaker::Name.name,
  receiver_rfc: FFaker::Bank.iban,
  amount: rand(1000..100_000_000),
  emitted_at: FFaker::Time.date.to_s,
  expires_at: FFaker::Time.date.to_s,
  signed_at: FFaker::Time.date.to_s,
  cfdi_digital_stamp: FFaker::Bank.iban,
  creator_id: User.first.id
)
Invoice.create(
  user_id: User.last.id,
  invoice_uuid: FFaker::SSN.ssn,
  status: 'active',
  emitter_name: FFaker::Name.name,
  emitter_rfc: FFaker::Bank.iban,
  receiver_name: FFaker::Name.name,
  receiver_rfc: FFaker::Bank.iban,
  amount: rand(1000..100_000_000),
  emitted_at: FFaker::Time.date.to_s,
  expires_at: FFaker::Time.date.to_s,
  signed_at: FFaker::Time.date.to_s,
  cfdi_digital_stamp: FFaker::Bank.iban,
  creator_id: User.first.id
)
Invoice.create(
  user_id: User.last.id,
  invoice_uuid: FFaker::SSN.ssn,
  status: 'active',
  emitter_name: FFaker::Name.name,
  emitter_rfc: FFaker::Bank.iban,
  receiver_name: FFaker::Name.name,
  receiver_rfc: FFaker::Bank.iban,
  amount: rand(1000..100_000_000),
  emitted_at: FFaker::Time.date.to_s,
  expires_at: FFaker::Time.date.to_s,
  signed_at: FFaker::Time.date.to_s,
  cfdi_digital_stamp: FFaker::Bank.iban,
  creator_id: user2
)
Invoice.create(
  user_id: User.last.id,
  invoice_uuid: FFaker::SSN.ssn,
  status: 'active',
  emitter_name: FFaker::Name.name,
  emitter_rfc: FFaker::Bank.iban,
  receiver_name: FFaker::Name.name,
  receiver_rfc: FFaker::Bank.iban,
  amount: rand(1000..100_000_000),
  emitted_at: FFaker::Time.date.to_s,
  expires_at: FFaker::Time.date.to_s,
  signed_at: FFaker::Time.date.to_s,
  cfdi_digital_stamp: FFaker::Bank.iban,
  creator_id: User.first.id
)
