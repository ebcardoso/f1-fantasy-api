Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :auth do
        post :signup
        post :signin
        post :verify_token
        post :forgot_password_token
        post :reset_password_confirm
      end

      namespace :profile do
        get :my_user
        post :update_password
      end
    end
  end
end
