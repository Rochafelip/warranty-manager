require 'swagger_helper'

RSpec.describe 'API Warranty Manager - Users', type: :request do
  let(:user_headers) do
    JSON.parse(File.read('tmp/user_headers.json'))
  end
  
  let(:admin_headers) do
    JSON.parse(File.read('tmp/admin_headers.json'))
  end

  # Criar Usuário
  # path '/auth' do
  #   post 'Cria um novo usuário' do
  #     tags 'Usuário'
  #     consumes 'application/json'
  #     parameter name: :user, in: :body, schema: {
  #       type: :object,
  #       properties: {
  #         name: { type: :string, example: 'Felipe' },
  #         email: { type: :string, example: 'felipe@email.com' },
  #         password: { type: :string, example: 'feliperocha' },
  #         confirm_password: { type: :string, example: 'feliperocha' },
  #         confirm_success_url: { type: :string, example: 'www.google.com' }
  #       },
  #       required: %w[name email password confirm_password]
  #     }

  #     response '200', 'OK' do
  #       let(:Authorization) { "Bearer #{auth_headers['access-token']}" } # Envia o token no header
  #       let(:user) do
  #         {
  #           name: 'Felipe',
  #           email: 'felipe@email.com',
  #           password: 'feliperocha',
  #           confirm_password: 'feliperocha',
  #           confirm_success_url: 'www.google.com'
  #         }
  #       end
  #       run_test!
  #     end

  #     response '422', 'Unprocessable Entity' do
  #       let(:Authorization) { "Bearer #{auth_headers['access-token']}" } # Envia o token no header
  #       let(:user) { { name: '', email: '', password: '' } }
  #       run_test!
  #     end
  #   end
  # end

  # Teste convencional RSpec (fora do bloco 'path')
  describe 'GET /users' do
    it 'retorna a lista de usuários quando autenticado como admin' do
      get '/users', headers: admin_headers
      expect(response).to have_http_status(:ok)
    end

    it 'retorna Forbidden (403) para usuários comuns' do
      get '/users', headers: user_headers
      expect(response).to have_http_status(:forbidden)
    end
  end

  # Bloco RSwag (para documentação Swagger)
  path '/users' do
    get 'Lista apenas usuários admin' do
      tags 'Usuário'
      produces 'application/json'
      security [Bearer: []]

      response '200', 'OK' do
        let(:Authorization) { "#{admin_headers['token-type']} #{admin_headers['access-token']}" }
        run_test!
      end

      response '403', 'Forbidden' do
        let(:Authorization) { "#{admin_headers['token-type']} #{admin_headers['access-token']}" }
        run_test!
      end
    end
  end

  # Buscar Usuário por ID
  # path '/users/{id}' do
  #   get 'Busca um usuário pelo ID' do
  #     tags 'Usuário'
  #     produces 'application/json'
  #     parameter name: :id, in: :path, type: :integer, required: true

  #     response '200', 'Usuário encontrado' do
  #       let(:id) { user.id } # Garante que está buscando um usuário existente
  #       run_test!
  #     end

  #     response '404', 'Usuário não encontrado' do
  #       let(:id) { 999 }
  #       run_test!
  #     end
  #   end

  # Atualizar Usuário
  # patch 'Atualiza informações de um usuário' do
  #   tags 'Usuário'
  #   consumes 'application/json'
  #   parameter name: :id, in: :path, type: :integer, required: true
  #   parameter name: :user, in: :body, schema: {
  #     type: :object,
  #     properties: {
  #       name: { type: :string, example: 'Felipe Atualizado' },
  #       role: { type: :string, example: 'admin' },
  #       admin: { type: :boolean, example: true }
  #     }
  #   }

  #   response '200', 'Usuário atualizado com sucesso' do
  #     let(:id) { user.id } # Usa o usuário criado
  #     let(:user) { { name: 'Felipe Atualizado', role: 'admin', admin: true } }
  #     run_test!
  #   end

  #   response '404', 'Usuário não encontrado' do
  #     let(:id) { 999 }
  #     run_test!
  #   end
  # end

  # Excluir Usuário
  #   delete 'Exclui um usuário' do
  #     tags 'Usuário'
  #     parameter name: :id, in: :path, type: :integer, required: true

  #     response '204', 'Usuário excluído com sucesso' do
  #       let(:id) { user.id } # Garante que o usuário existe antes do delete
  #       run_test!
  #     end

  #     response '404', 'Usuário não encontrado' do
  #       let(:id) { 999 }
  #       run_test!
  #     end
  #   end
  # end
end
