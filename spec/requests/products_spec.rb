require 'swagger_helper'

RSpec.describe 'API Warranty Manager - Products', type: :request do

  # Criar Produto
  path '/products' do
    post 'Cria um novo produto' do
      tags 'Produtos'
      consumes 'application/json'
      parameter name: :product, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: 'Notebook Dell XPS' },
          description: { type: :string, example: 'Ultrabook com 16GB de RAM e 512GB SSD' },
          price: { type: :number, format: 'float', example: 7999.99 },
          user_id: { type: :integer, example: 4 }
        },
        required: [ 'name', 'price', 'user_id' ]
      }

      response '201', 'Produto criado com sucesso' do
        let(:product) { { name: 'Notebook Dell XPS', description: 'Ultrabook com 16GB de RAM e 512GB SSD', price: 7999.99, user_id: 4 } }
        run_test!
      end

      response '422', 'Erro na criação do produto' do
        let(:product) { { name: '', price: '', user_id: '' } }
        run_test!
      end
    end

    # Listar Produtos
    get 'Lista todos os produtos' do
      tags 'Produtos'
      produces 'application/json'

      response '200', 'Produtos listados com sucesso' do
        run_test!
      end
    end
  end

  # Operações por ID do Produto
  path '/products/{id}' do
    get 'Busca um produto pelo ID' do
      tags 'Produtos'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, required: true

      response '200', 'Produto encontrado' do
        let(:id) { 1 }
        run_test!
      end

      response '404', 'Produto não encontrado' do
        let(:id) { 999 }
        run_test!
      end
    end

    # Atualizar Produto
    patch 'Atualiza informações de um produto' do
      tags 'Produtos'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer, required: true
      parameter name: :product, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: 'Notebook Dell XPS Atualizado' },
          description: { type: :string, example: 'Atualização: 32GB RAM, 1TB SSD' },
          price: { type: :number, format: 'float', example: 9999.99 }
        }
      }

      response '200', 'Produto atualizado com sucesso' do
        let(:id) { 1 }
        let(:product) { { name: 'Notebook Dell XPS Atualizado', description: 'Atualização: 32GB RAM, 1TB SSD', price: 9999.99 } }
        run_test!
      end

      response '404', 'Produto não encontrado' do
        let(:id) { 999 }
        run_test!
      end
    end

    # Excluir Produto
    delete 'Exclui um produto' do
      tags 'Produtos'
      parameter name: :id, in: :path, type: :integer, required: true

      response '204', 'Produto excluído com sucesso' do
        let(:id) { 1 }
        run_test!
      end

      response '404', 'Produto não encontrado' do
        let(:id) { 999 }
        run_test!
      end
    end
  end
end