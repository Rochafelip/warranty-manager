#!/bin/bash

# Executa as migrations e seed com reset
bundle exec rails db:drop db:create db:migrate db:seed

# Inicia o servidor normalmente
bundle exec puma -C config/puma.rb