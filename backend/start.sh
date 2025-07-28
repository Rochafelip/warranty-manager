#!/bin/bash

# Fail fast
set -e

echo "📦 Instalando dependências..."
bundle install

echo "🧬 Migrando banco de dados..."
RAILS_ENV=production bundle exec rails db:migrate

echo "🌱 Rodando seeds..."
RAILS_ENV=production bundle exec rails db:seed

echo "🚀 Iniciando o servidor Puma..."
RAILS_ENV=production bundle exec puma -C config/puma.rb