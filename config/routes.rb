Rails.application.routes.draw do
  # devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # root to: "users#index"

  devise_for :users, defaults: { format: :json }, path: '',
               path_names: {
                 sign_in: 'login',
                 registration: 'signup'
               },
               controllers: {
                 sessions: 'sessions',
                 registrations: 'registrations'
               }

    scope module: 'api', defaults: { format: :json } do
      namespace :v1 do
      
        resources :tweets, only: [:create]

        post 'user/follow', to: 'users#follow' 
        delete 'user/unfollow', to: 'users#unfollow'

        get 'show/follower', to: 'users#show_current_user_follower'
        get 'show/following', to: 'users#show_current_user_followings'

        get 'show/tweets', to: 'tweets#show_tweets'

      end
    end

  
end
