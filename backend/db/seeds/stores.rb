puts 'Seeding Stores...'

stores_data = [
  { name: 'Grillo', contact: 'grillo@gmail.com', address: 'Rua Qualquer, 50, Centro, Recife-PE' },
  { name: 'Cobasi', contact: 'cobasi@gmail.com', address: 'Rua Alvorada, 89, Matriz, Caruaru-PE' },
  { name: 'Segurança Valores', contact: 'seg.valores@gmail.com', address: 'Av. Olavo Bilac, 356, Cajá, Recife-PE' },
  { name: 'Microlite', contact: 'microlite@gmail.com', address: 'Rua Projetada, 45, Curado, Jaboatão-PE' },
  { name: 'Exército Fitness', contact: 'e.fitnes@gmail.com', address: 'Rua Leonardo, 70, Santo, Recife-PE' }
]

stores_data.each do |store_data|
  store = Store.find_or_initialize_by(name: store_data[:name])
  store.assign_attributes(store_data)
  if store.save
    puts "✅ Store criada: #{store.name}"
  else
    puts "❌ Erro ao criar store: #{store.errors.full_messages.join(', ')}"
  end
end

stores = Store.all
