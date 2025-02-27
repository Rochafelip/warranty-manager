require 'faker'

# Limpar o banco de dados (cuidado com produção)
Warranty.destroy_all
Product.destroy_all
Invoice.destroy_all
Store.destroy_all
User.destroy_all

pdf_path = Rails.root.join('db/seeds/files/invoice.pdf')

# Criar Usuários
10.times do
  first_name = nil
  last_name = nil

  # Garante que first_name tenha pelo menos 3 caracteres
  loop do
    first_name = Faker::Name.first_name.gsub(/[^a-zA-Z\s]/, '')
    break if first_name.length >= 3
  end

  # Garante que last_name tenha pelo menos 3 caracteres
  loop do
    last_name = Faker::Name.last_name.gsub(/[^a-zA-Z\s]/, '')
    break if last_name.length >= 3
  end

  User.create!(
    name: "#{first_name} #{last_name}", # Nome completo
    email: "#{first_name.downcase}.#{last_name.downcase}@email.com",
    password: 'feliperocha',
    password_confirmation: 'feliperocha'
  )
end

# Criar Lojas
5.times do
  Store.create!(
    name: Faker::Company.name.truncate(45),
    contact: "#{Faker::Internet.username}@email.com",
    address: Faker::Address.full_address.truncate(45)
  )
end

# Criar Invoices
20.times do
  issue_date = Faker::Date.backward(days: 365) # Data de emissão primeiro
  purchase_date = issue_date - rand(1..30) # Garante que a data da compra seja antes ou no mesmo dia

  Invoice.create!(
    invoice_number: Faker::Number.unique.number(digits: 10),
    purchase_date: purchase_date,
    issue_date: issue_date,
    user_id: User.order('RANDOM()').first.id,
    pdf: { io: File.open(pdf_path, 'rb'), filename: 'invoice.pdf', content_type: 'application/pdf' }
  )
end

# Criar Produtos
30.times do
  Product.create!(
    name: Faker::Commerce.product_name,
    description: Faker::Lorem.sentence,
    category: Faker::Commerce.department,
    price: Faker::Commerce.price(range: 100.0..5000.0),
    serial_number: Faker::Device.serial,
    warranty_expiry_date: Faker::Date.forward(days: 730),
    store_id: Store.order('RANDOM()').first.id,
    invoice_id: Invoice.order('RANDOM()').first.id
  )
end

# Criar Garantias (Warranties)
40.times do
  Warranty.create!(
    warranty_number: Faker::Number.unique.number(digits: 12),
    issue_date: Faker::Date.backward(days: 300),
    expirity_date: Faker::Date.forward(days: 400),
    validity_period: rand(12..36), # validade entre 1 a 3 anos
    product_id: Product.order('RANDOM()').first.id
  )
end

puts '✅ Dados de teste criados com sucesso!'
