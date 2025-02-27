require 'swagger_helper'

RSpec.describe 'API Warranty Manager - Stores', type: :request do

  # Criar Loja
  path '/stores' do
    post 'Cria uma nova loja' do
      tags 'Lojas'
      consumes 'application/json'
      parameter name: :store, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: 'Tech Store' },
          address: { type: :string, example: 'Av. Paulista, 1000' },
          phone: { type: :string, example: '(11) 99999-9999' }
        },
        required: [ 'name', 'address' ]
      }

      response '201', 'Loja criada com sucesso' do
        let(:store) { { name: 'Tech Store', address: 'Av. Paulista, 1000', phone: '(11) 99999-9999' } }
        run_test!
      end

      response '422', 'Erro na criação da loja' do
        let(:store) { { name: '', address: '' } }
        run_test!
      end
    end

    # Listar Lojas
    get 'Lista todas as lojas' do
      tags 'Lojas'
      produces 'application/json'

      response '200', 'Lojas listadas com sucesso' do
        run_test!
      end
    end
  end

  # Operações por ID da Loja
  path '/stores/{id}' do
    get 'Busca uma loja pelo ID' do
      tags 'Lojas'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, required: true

      response '200', 'Loja encontrada' do
        let(:id) { 1 }
        run_test!
      end

      response '404', 'Loja não encontrada' do
        let(:id) { 999 }
        run_test!
      end
    end

    # Atualizar Loja
    patch 'Atualiza informações de uma loja' do
      tags 'Lojas'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer, required: true
      parameter name: :store, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: 'Tech Store Atualizada' },
          address: { type: :string, example: 'Av. Brasil, 2000' },
          phone: { type: :string, example: '(11) 98888-8888' }
        }
      }

      response '200', 'Loja atualizada com sucesso' do
        let(:id) { 1 }
        let(:store) { { name: 'Tech Store Atualizada', address: 'Av. Brasil, 2000', phone: '(11) 98888-8888' } }
        run_test!
      end

      response '404', 'Loja não encontrada' do
        let(:id) { 999 }
        run_test!
      end
    end

    # Excluir Loja
    delete 'Exclui uma loja' do
      tags 'Lojas'
      parameter name: :id, in: :path, type: :integer, required: true

      response '204', 'Loja excluída com sucesso' do
        let(:id) { 1 }
        run_test!
      end

      response '404', 'Loja não encontrada' do
        let(:id) { 999 }
        run_test!
      end
    end
  end
end
