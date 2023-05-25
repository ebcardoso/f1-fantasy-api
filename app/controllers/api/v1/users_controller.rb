class Api::V1::UsersController < ApiController
  def create
    UsersServices::Create::Transaction.call(params) do |on|
      on.failure(:validate_inputs) {|message, content| render json: {message: message, content: content}, status: 400}
      on.failure(:persist_user) {|message| render json: {message: message, content: {}}, status: 500}
      on.success {|response| render json: response, status: 200}
    end
  end
end
