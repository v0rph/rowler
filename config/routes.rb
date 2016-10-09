Rails.application.routes.draw do
  scope module: 'api' do
     namespace :v1 do
       resources :games, only: [:create, :show, :update]
     end
   end
end
