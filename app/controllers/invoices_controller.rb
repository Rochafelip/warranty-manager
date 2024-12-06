class InvoicesController < ApplicationController
  def index
    @q = policy_scope(Invoice).ransack(params[:q])
    @invoices = @q.result

    render json: @invoices.map { |invoice| InvoiceSerializer.call(invoice) }
  end

  def show
    authorize invoice

    render json: InvoiceSerializer.call(@invoice)
  end

  def create
    authorize Invoice
    @invoice = current_user.invoices.create(invoice_params)

    render json: InvoiceSerializer.call(@invoice), status: :created
  end

  def update
    authorize invoice
    invoice.update(invoice_params)

    render json: InvoiceSerializer.call(@invoice), status: :ok
  end

  def destroy
    authorize invoice

    invoice.products.each do |product|
      ProductHistory.create!(
        name: product.name,
        description: product.description,
        category: product.category,
        price: product.price,
        serial_number: product.serial_number,
        warranty_expiry_date: product.warranty_expiry_date,
        user: product.invoice.user
      )
    end

    invoice.destroy

    head :no_content
  end

  private

  def invoice
    @invoice = Invoice.find(params[:id])
  end

  def invoice_params
    params.require(:invoice).permit(:invoice_number, :purchase_date, :issue_date, :pdf)
  end
end
