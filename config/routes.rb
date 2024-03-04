Rails.application.routes.draw do
  devise_for :users
  root to: "timelines#index"

  get 'report', to: 'pages#report'
  get 'dashboard_lc', to: 'pages#dashboard_lc'
  get 'edit_profile', to: 'pages#edit_profile'
  post '/update_profile', to: 'pages#update_profile', as: :update_profile
  get '/get_topics', to: 'subjects#get_topics'
  patch '/timelines/:id/update_done_topics', to: 'timelines#update_done_topics', as: 'update_done_topics'


  resources :subjects do
    resources :topics, except: [:show, :index]
  end

  get 'profile', to: 'pages#profile'
  resources :holidays, except: [:show, :index]
  resources :timelines
  resources :weekly_goals
  resources :sprint_goals
  resources :kdas
  resources :user_topics do
    member do
      patch :update_done
    end
  end

end
