require 'swagger_helper'

RSpec.describe 'API Warranty Manager - Warranties', type: :request do

  # Criar Garantia
  path '/warranties' do
    post 'Cria uma nova garantia' do
      tags 'Garantias'
      consumes 'application/json'
      parameter name: :warranty, in: :body, schema: {
        type: :object,
        properties: {
          product_id: { type: :integer, example: 1 },
          user_id: { type: :integer, example: 4 },
          start_date: { type: :string, format: 'date', example: '2025-02-04' },
          end_date: { type: :string, format: 'date', example: '2026-02-04' },
          status: { type: :string, example: 'active' }
        },
        required: [ 'product_id', 'user_id', 'start_date', 'end_date', 'status' ]
      }

      response '201', 'Garantia criada com sucesso' do
        let(:warranty) { { product_id: 1, user_id: 4, start_date: '2025-02-04', end_date: '2026-02-04', status: 'active' } }
        run_test!
      end

      response '422', 'Erro na criação da garantia' do
        let(:warranty) { { product_id: '', start_date: '', end_date: '' } }
        run_test!
      end
    end

    # Listar Garantias
    get 'Lista todas as garantias' do
      tags 'Garantias'
      produces 'application/json'

      response '200', 'Garantias listadas com sucesso' do
        run_test!
      end
    end
  end

  # Operações por ID da Garantia
  path '/warranties/{id}' do
    get 'Busca uma garantia pelo ID' do
      tags 'Garantias'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, required: true

      response '200', 'Garantia encontrada' do
        let(:id) { 1 }
        run_test!
      end

      response '404', 'Garantia não encontrada' do
        let(:id) { 999 }
        run_test!
      end
    end

    # Atualizar Garantia
    patch 'Atualiza informações de uma garantia' do
      tags 'Garantias'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer, required: true
      parameter name: :warranty, in: :body, schema: {
        type: :object,
        properties: {
          start_date: { type: :string, format: 'date', example: '2025-03-01' },
          end_date: { type: :string, format: 'date', example: '2026-03-01' },
          status: { type: :string, example: 'expired' }
        }
      }

      response '200', 'Garantia atualizada com sucesso' do
        let(:id) { 1 }
        let(:warranty) { { start_date: '2025-03-01', end_date: '2026-03-01', status: 'expired' } }
        run_test!
      end

      response '404', 'Garantia não encontrada' do
        let(:id) { 999 }
        run_test!
      end
    end

    # Excluir Garantia
    delete 'Exclui uma garantia' do
      tags 'Garantias'
      parameter name: :id, in: :path, type: :integer, required: true

      response '204', 'Garantia excluída com sucesso' do
        let(:id) { 1 }
        run_test!
      end

      response '404', 'Garantia não encontrada' do
        let(:id) { 999 }
        run_test!
      end
    end
  end
end
