Rails.application.routes.draw do

  resources :topics do
    resources :posts, except: [:index]
    resources :sponsored_posts, except: [:index]
  end
  resources :posts, only: [] do 
    resources :comments, only: [:create, :destroy]
    resources :favorites, only: [:create, :destroy]
    post '/up-vote' => 'votes#up_vote', as: :up_vote
    post '/down-vote' => 'votes#down_vote', as: :down_vote
  end

  resources :questions

  resources :advertisements

  resources :users, only: [:new, :create, :show]

  resources :sessions, only: [:new, :create, :destroy]

  post 'users/confirm' => 'users#confirm'

  get 'about' => 'welcome#about'

  get 'contact' => 'welcome#contact'

  get 'faq' => 'welcome#faq'

  root 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
