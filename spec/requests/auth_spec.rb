require 'swagger_helper'
require 'json'

RSpec.describe 'API Warranty Manager - Auth', type: :request do
  before(:all) do
    @user = User.find_by(email: 'magnolia.kozey@email.com')
    @admin = User.find_by(email: 'dan.kozey@email.com')
  end

  def save_token(role, headers)
    token_data = headers.slice('access-token', 'token-type', 'client', 'expiry', 'uid')
    File.write("tmp/#{role}_headers.json", token_data.to_json)
  end

  path '/auth/sign_in' do
    post 'Autentica o usuário e retorna tokens' do
      tags 'Autenticação'
      consumes 'application/json'
      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'exemplo@email.com' },
          password: { type: :string, example: 'senha123' }
        },
        required: %w[email password]
      }

      response '200', 'OK - Admin autenticado' do
        let(:credentials) { { email: @admin.email, password: 'feliperocha' } }

        before do
          post '/auth/sign_in', params: credentials
          save_token('admin', response.headers) if response.status == 200
        end

        run_test!
      end

      response '200', 'OK - Usuário autenticado' do
        let(:credentials) { { email: @user.email, password: 'feliperocha' } }

        before do
          post '/auth/sign_in', params: credentials
          save_token('user', response.headers) if response.status == 200
        end

        run_test!
      end

      response '401', 'Unauthorized' do
        let(:credentials) { { email: 'email@invalido.com', password: 'senha_errada' } }
        run_test!
      end
    end
  end
end
