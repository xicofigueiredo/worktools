Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  authenticate :user do
  root to: "timelines#index"

  get 'profile', to: 'pages#profile'
  get 'report', to: 'pages#report'
  get 'edit_profile', to: 'pages#edit_profile'
  post '/update_profile', to: 'pages#update_profile', as: :update_profile
  get '/get_topics', to: 'subjects#get_topics'
  patch '/timelines/:id/update_done_topics', to: 'timelines#update_done_topics', as: 'update_done_topics'
  get '/about', to: 'pages#about'
    get 'dashboard_admin', to: 'pages#dashboard_admin'
    get 'dashboard_lc', to: 'pages#dashboard_lc'
  end

  resources :subjects do
    resources :topics, except: [:show, :index]
  end

  resources :holidays, except: [:show, :index]
  resources :timelines
  resources :weekly_goals do
    get 'topics_for_subject/:subject_id', on: :collection, to: 'weekly_goals#topics_for_subject'
  end
  resources :sprint_goals do
    resources :knowledges, only: [:create, :update, :destroy]
    resources :skills, only: [:create, :update, :destroy]
    resources :communities, only: [:create, :update, :destroy]
  end

  resources :kdas
  resources :user_topics do
    member do
      patch :toggle_done
    end
  end

end
