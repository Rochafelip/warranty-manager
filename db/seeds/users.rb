puts 'Seeding Users...'

users_data = [
  { name: 'Joao Alexandre', email: 'jalexandre@example.com', password: 'password', role: 'admin', admin: 1 },
  { name: 'Frederico Evandro', email: 'fevandro@example.com', password: 'password', role: 'admin', admin: 1 },
  { name: 'Marina Aragao', email: 'maragao@example.com', password: 'password', role: 'user', admin: 0 },
  { name: 'Roberto Freitas', email: 'rfreitas@example.com', password: 'password', role: 'user', admin: 0 },
  { name: 'Josefa Pereira', email: 'jperreira@example.com', password: 'password', role: 'user', admin: 0 }
]

users_data.each do |user_data|
  user = User.find_or_initialize_by(email: user_data[:email])
  user.assign_attributes(
    name: user_data[:name],
    password: user_data[:password],
    password_confirmation: user_data[:password],
    role: user_data[:role],
    admin: user_data[:admin] == 1,
    provider: 'email'
  )

  if user.save
    puts I18n.t('seed.users.success', email: user.email)
  else
    puts I18n.t('seed.users.error', message: user.errors.full_messages.join(', '))
  end
end
