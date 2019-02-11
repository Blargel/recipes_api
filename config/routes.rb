Rails.application.routes.draw do
  resources :users do
    resources :recipes
  end
end
