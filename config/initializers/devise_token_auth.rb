# frozen_string_literal: true

DeviseTokenAuth.setup do |config|


  config.change_headers_on_each_request = false

  config.enable_standard_devise_support = true

  config.token_cost = Rails.env.test? ? 4 : 10

  config.check_current_password_before_update = :attributes
end
