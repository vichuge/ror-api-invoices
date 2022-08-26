require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let!(:users) { create_list(:user, 5) }
  let!(:user) { users.first }

  # Test suite for GET api/v1/users
  describe 'GET api/v1/users' do
    before { get '/api/v1/users', headers: { 'Authorization' => AuthenticationTokenService.call(user.id) } }

    it 'returns users' do
      expect(json).not_to be_empty
      expect(json.size).to eq(5)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:ok)
    end
  end

  # Test suite for POST api/v1/regisrer
  describe 'POST /register' do
    it 'authenticates the user' do
      post '/api/v1/register', params: { user: { username: 'user1', password: 'password' } }
      expect(response).to have_http_status(:created)
      expect(json).to eq({
                           'id' => User.last.id,
                           'username' => 'user1',
                           'token' => AuthenticationTokenService.call(User.last.id)
                         })
    end
  end
end
