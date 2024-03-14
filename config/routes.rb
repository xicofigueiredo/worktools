Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  root to: "timelines#index"

  get 'profile', to: 'pages#profile'
  get 'report', to: 'pages#report'
  get 'dashboard_lc', to: 'pages#dashboard_lc'
  get 'edit_profile', to: 'pages#edit_profile'
  post '/update_profile', to: 'pages#update_profile', as: :update_profile
  get '/get_topics', to: 'subjects#get_topics'
  patch '/timelines/:id/update_done_topics', to: 'timelines#update_done_topics', as: 'update_done_topics'
  get '/about', to: 'pages#about'

  resources :subjects do
    resources :topics, except: [:show, :index]
  end

  resources :holidays, except: [:show, :index]
  resources :timelines
  resources :weekly_goals do
    get 'topics_for_subject/:subject_id', on: :collection, to: 'weekly_goals#topics_for_subject'
  end
  resources :sprint_goals
  resources :kdas
  resources :user_topics do
    member do
      patch :toggle_done
    end
  end

end
