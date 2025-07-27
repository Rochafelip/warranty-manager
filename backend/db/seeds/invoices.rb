puts 'Seeding Invoices...'

users = User.limit(7).to_a
invoice_numbers = (1..50).map { |i| "INV#{i.to_s.rjust(4, '0')}" } # exemplo: INV0001, INV0002...

invoice_numbers.each do |invoice_number|
  next if Invoice.exists?(invoice_number: invoice_number)

  user = users.sample
  purchase_date = Date.today - rand(10..30)
  issue_date = purchase_date + rand(0..1)

  invoice = Invoice.new(
    invoice_number: invoice_number,
    purchase_date: purchase_date,
    issue_date: issue_date,
    user_id: user.id
  )

  pdf_path = Rails.root.join('lib', 'assets', 'invoice.pdf')

  if File.exist?(pdf_path)
    invoice.pdf.attach(io: File.open(pdf_path), filename: 'invoice.pdf', content_type: 'application/pdf')

    if invoice.save
      puts "✅ Invoice #{invoice.invoice_number} criada para o usuário #{user.email}"
    else
      puts "❌ Erro ao criar invoice #{invoice.invoice_number}: #{invoice.errors.full_messages.join(', ')}"
    end
  else
    puts "❌ Arquivo PDF não encontrado: #{pdf_path}"
  end
end
