module AuthServices
  module Signup
    class Contract < ApplicationContract
      schema do
        required(:name).value(:string)
        required(:email).value(:string)
        required(:password).value(:string)
        required(:password_confirmation).value(:string)
      end
      
      rule(:name) do
        key.failure('Name must to have at least 6 characters') if value.length < 6
      end
      
      rule(:password) do
        key.failure('Password must to have at least 6 characters') if value.length < 6
      end
    end
  end
end
