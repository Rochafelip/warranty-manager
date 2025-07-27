puts 'Seeding Products...'

stores = Store.all.to_a
invoices = Invoice.all.to_a

products_data = (1..100).map do |i|
  category = case i % 6
             when 0 then 'eletronico'
             when 1 then 'eletrodomestico'
             when 2 then 'móvel'
             when 3 then 'moto'
             when 4 then 'automovel'
             when 5 then 'livro e revista'
             end

  warranty_period = case category
                    when 'livro e revista', 'móvel' then 3
                    when 'eletronico', 'eletrodomestico' then 12
                    when 'automovel', 'moto' then 24
                    end

  invoice = invoices.sample
  store = stores.sample

  {
    name: "Produto #{i}".slice(0, 45),  # garante máximo 45 caracteres
    description: "Descrição do produto #{i}",
    category: category,
    price: rand(100..10000).to_f.round(2),
    serial_number: "#{i.to_s.rjust(15, '0')}",
    warranty_expiry_date: invoice.issue_date + warranty_period.months,
    invoice_id: invoice.id,
    store_id: store.id
  }
end

products_data.each do |product_data|
  next if Product.exists?(serial_number: product_data[:serial_number])

  product = Product.new(product_data)

  if product.save
    puts "✅ Produto criado: #{product.serial_number} (#{product.name})"
  else
    puts "❌ Erro ao criar produto #{product.serial_number}: #{product.errors.full_messages.join(', ')}"
  end
end
