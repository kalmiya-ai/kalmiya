# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users' do
  subject { response }

  describe 'GET /user/new' do
    before { get '/user/new' }

    it { is_expected.to have_http_status :ok }
  end

  describe 'POST /user' do
    context 'with valid parameters' do
      let(:user) { attributes_for(:user) }

      before { post '/user', params: { user: } }

      it { is_expected.to redirect_to '/user/new' }

      it 'creates a user' do
        expect(User.find_by(email: user[:email])).to have_attributes(**user.slice(:id, :name, :email))
      end
    end
  end
end
