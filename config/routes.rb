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

  # Attendances Routes
  get '/attendance', to: 'attendances#attendance'
  get '/attendances/:time_frame', to: 'attendances#index', as: :attendances_by_time_frame
  get '/attendance/:learner_id', to: 'attendances#learner_attendances', as: 'learner_attendances'
  put '/attendances/update_attendance', to: 'attendances#update_attendance', as: :update_attendance
  patch '/attendances/:id/save_comment', to: 'attendances#save_comment', as: :patch_attendance_comment
  patch '/attendances/:id/update_absence', to: 'attendances#update_absence', as: :update_absence_attendance
  patch '/attendances/:id/update_time', to: 'attendances#update_time', as: :update_time_attendance
  end

  get 'topics_for_subject', to: 'weekly_goals#topics_for_subject'

  resources :subjects do
    resources :topics, except: [:show, :index]
  end

  resources :holidays, except: [:show, :index]
  resources :timelines
  resources :weekly_goals do
    resources :weekly_slots
  end
  resources :weekly_meetings do
    resources :monday_slots, except: [:index]
    resources :tuesday_slots, except: [:index]
    resources :wednesday_slots, except: [:index]
    resources :thursday_slots, except: [:index]
    resources :friday_slots, except: [:index]
  end

  resources :exam_dates

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
