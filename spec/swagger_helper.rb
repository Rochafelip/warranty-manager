# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  config.openapi_root = Rails.root.to_s + '/swagger'
  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API Warranty Manager',
        version: 'v1'
      },
      paths: {},
      servers: [
        {
          url: 'http://localhost:4000',
          description: 'Servidor Local'
        }
      ]
    }
  }
end
