# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Session do
  subject(:session) { active_session }

  let(:active_session)  { create(:session)           }
  let(:expired_session) { create(:session, :expired) }

  it { is_expected.to be_valid }

  describe '.active' do
    subject { described_class.active }

    it { is_expected.to     include active_session  }
    it { is_expected.not_to include expired_session }
  end

  describe '.expired' do
    subject { described_class.expired }

    it { is_expected.not_to include active_session  }
    it { is_expected.to     include expired_session }
  end

  describe '.from_jwt' do
    subject { described_class.from_jwt(jwt) }

    let(:jwt) { session.to_jwt }

    it { is_expected.to have_attributes id: session.id, user_id: session.user_id }
  end

  describe '#expires_at' do
    subject { session.expires_at }

    before { travel_to now }

    let(:session) { create(:session)             }
    let(:now)     { session.created_at + 15.days }

    it { is_expected.to be_the_same_time_as(session.created_at + 30.days) }
    it { is_expected.to be_the_same_time_as(now + 15.days)                }

    context 'when session is saved' do
      before { session.save! }

      it { is_expected.to be_the_same_time_as(now + 30.days) }
    end
  end
end
