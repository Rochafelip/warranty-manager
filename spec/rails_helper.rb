# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

# Impede que testes sejam rodados em produção por segurança
abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'
require 'devise'
require 'database_cleaner/active_record'

# Aplica todas as configurações dentro de spec/support/
Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  # Inclui Devise nos testes de request e controller
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::ControllerHelpers, type: :controller

  # Configuração para evitar que logs e mensagens de erro poluam os testes
  config.before(:each) do
    Rails.application.routes.default_url_options[:host] = 'localhost'
  end

  # Filtra linhas do Rails nos logs para facilitar a leitura dos erros nos testes
  config.filter_rails_from_backtrace!
end
