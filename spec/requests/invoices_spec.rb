require 'swagger_helper'

RSpec.describe 'API Warranty Manager - Invoices', type: :request do
  path '/invoices' do
    post 'Cria uma nova nota fiscal' do
      tags 'Notas Fiscais'
      consumes 'multipart/form-data'
      parameter name: :invoice, in: :formData, schema: {
        type: :object,
        properties: {
          'invoice[invoice_number]': { type: :string, example: 'INV202504022040' },
          'invoice[purchase_date]': { type: :string, format: 'date', example: '2025-02-04' },
          'invoice[issue_date]': { type: :string, format: 'date', example: '2025-02-04' },
          'invoice[pdf]': { type: :string, format: 'binary' }
        },
        required: ['invoice[invoice_number]', 'invoice[purchase_date]', 'invoice[issue_date]', 'invoice[user_id]']
      }

      response '201', 'Created' do
        let(:invoice) do
          { 'invoice[invoice_number]': 'INV20250414', 'invoice[purchase_date]': '2025-02-04',
            'invoice[issue_date]': '2025-02-04' }
        end
        run_test!
      end

      response '422', 'unprocessable_entity' do
        let(:invoice) { { 'invoice[invoice_number]': '' } }
        schema type: :object,
               properties: {
                 errors: { type: :array, items: { type: :string }, example: ["Número da nota fiscal é obrigatório"] }
               }
        run_test!
      end
    end

    get 'Lista todas as notas fiscais' do
      tags 'Notas Fiscais'
      produces 'application/json'

      response '200', 'Notas fiscais listadas com sucesso' do
        run_test!
      end
    end
  end

  path '/invoices/{id}' do
    get 'Busca uma nota fiscal pelo ID' do
      tags 'Notas Fiscais'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, required: true

      response '200', 'Ok' do
        let(:id) { 1 }
        run_test!
      end

      response '404', 'Nota fiscal não encontrada' do
        let(:id) { 999 }
        run_test!
      end
    end

    patch 'Atualiza informações de uma nota fiscal' do
      tags 'Notas Fiscais'
      consumes 'multipart/form-data'
      parameter name: :id, in: :path, type: :integer, required: true
      parameter name: :invoice, in: :formData, schema: {
        type: :object,
        properties: {
          'invoice[invoice_number]': { type: :string, example: 'INV202504022999' },
          'invoice[purchase_date]': { type: :string, format: 'date', example: '2025-03-01' },
          'invoice[issue_date]': { type: :string, format: 'date', example: '2025-03-02' },
          'invoice[pdf]': { type: :string, format: 'binary' }
        }
      }

      response '200', 'Nota fiscal atualizada com sucesso' do
        let(:id) { 1 }
        let(:invoice) do
          { 'invoice[invoice_number]': 'INV202504022999', 'invoice[purchase_date]': '2025-03-01',
            'invoice[issue_date]': '2025-03-02' }
        end
        run_test!
      end

      response '404', 'Nota fiscal não encontrada' do
        let(:id) { 999 }
        run_test!
      end
    end

    delete 'Exclui uma nota fiscal' do
      tags 'Notas Fiscais'
      parameter name: :id, in: :path, type: :integer, required: true

      response '204', 'Nota fiscal excluída com sucesso' do
        let(:id) { 1 }
        run_test!
      end

      response '404', 'Nota fiscal não encontrada' do
        let(:id) { 999 }
        run_test!
      end
    end
  end
end
