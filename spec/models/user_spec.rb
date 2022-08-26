require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to validate_presence_of(:username) }
  it { is_expected.to validate_uniqueness_of(:username) }

  it {
    expect(subject).to validate_length_of(:username)
      .is_at_least(1)
  }

  it { is_expected.to validate_presence_of(:password) }

  it {
    expect(subject).to validate_length_of(:password)
      .is_at_least(5)
  }

  describe 'Associations' do
    it { is_expected.to have_many(:invoices) }
  end
end
