#!/bin/bash

# Fail fast
set -e

echo "📦 Instalando dependências..."
bundle install

echo "🧬 Migrando banco de dados..."
bundle exec rails db:migrate

echo "🌱 Rodando seeds..."
bundle exec rails db:seed

echo "🚀 Iniciando o servidor Puma..."
bundle exec puma -C config/puma.rb
