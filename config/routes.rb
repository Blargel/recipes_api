Rails.application.routes.draw do
  resources :users do
    resources :recipes do
      resources :recipe_steps
    end
  end

  post 'authenticate', to: 'authentication#authenticate'
end
