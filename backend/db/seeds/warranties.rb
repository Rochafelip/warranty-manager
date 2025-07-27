puts 'Seeding Warranties...'

products = Product.all.to_a

products.each_with_index do |product, index|
  # Evitar duplicação de warranty para um mesmo produto
  next if Warranty.exists?(product_id: product.id)

  issue_date = product.invoice.issue_date
  validity_period = ((product.warranty_expiry_date.year * 12 + product.warranty_expiry_date.month) - (issue_date.year * 12 + issue_date.month))
  expirity_date = product.warranty_expiry_date

  warranty_number = "WAR#{(index + 1).to_s.rjust(6, '0')}"  # Ex: WAR000001, WAR000002

  warranty = Warranty.new(
    warranty_number: warranty_number,
    issue_date: issue_date,
    expirity_date: expirity_date,
    validity_period: validity_period, # em meses (exemplo)
    product: product
  )

  if warranty.save
    puts "✅ Warranty #{warranty.warranty_number} criada para produto #{product.name}"
  else
    puts "❌ Erro ao criar warranty para produto #{product.name}: #{warranty.errors.full_messages.join(', ')}"
  end
end
