Rails.application.routes.draw do
  get 'responses/create'
  get 'forms/index'
  get 'forms/show'
  get '/unsupported_browser', to: 'static#unsupported_browser', as: :unsupported_browser
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    sessions: 'users/sessions'
  }
  authenticate :user do
    root to: "pages#profile"

    get 'after_signup', to: 'users/registrations#after_signup', as: 'after_signup'
    get 'profile', to: 'pages#profile'
    get 'edit_profile', to: 'pages#edit_profile'
    post '/update_profile', to: 'pages#update_profile', as: :update_profile
    get '/get_topics', to: 'subjects#get_topics'
    patch '/timelines/:id/update_done_topics', to: 'timelines#update_done_topics', as: 'update_done_topics'
    get '/about', to: 'pages#about'
    get 'dashboard_admin', to: 'pages#dashboard_admin'
    get 'dashboard_lc', to: 'pages#dashboard_lc'
    get 'dashboard_cm', to: 'pages#dashboard_cm'
    get 'cm_learners', to: 'pages#cm_learners'
    patch '/learner/:id/update_name', to: 'pages#update_learner_name', as: :update_learner_name
    get 'dashboard_dc', to: 'pages#dashboard_dc'
    get 'learner_profile/:id', to: 'pages#learner_profile', as: 'learner_profile'
    get 'change_weekly_goal/:date/:current_week_id/:learner_id/:current_date', to: 'pages#change_weekly_goal', as: 'change_weekly_goal'
    get 'change_sprint_goal/:current_sprint_id/:learner_id/', to: 'pages#change_sprint_goal', as: 'change_sprint_goal'
    get 'change_kda/:date/:current_week_id/:learner_id/:current_date', to: 'pages#change_kda', as: 'change_kda'
    get 'weekly_goals/:id/lc_edit', to: 'weekly_goals#lc_edit', as: 'lc_edit_weekly_goal'
    patch 'weekly_goals/:id/lc_update', to: 'weekly_goals#lc_update', as: 'lc_update_weekly_goal'
    post '/api/update_course_topics', to: 'moodle_api#update_course_topics', as: :update_course_topics


    # Attendances Routes
    get '/attendance', to: 'attendances#attendance'
    get '/attendances/:time_frame', to: 'attendances#index', as: :attendances
    get '/attendance/:learner_id', to: 'attendances#learner_attendances', as: 'learner_attendances'
    put '/attendances/update_attendance', to: 'attendances#update_attendance', as: :update_attendance
    patch '/attendance/:id/update_absence', to: 'attendances#update_absence', as: :update_absence_attendance
    patch 'attendance/:id/update_start_time', to: 'attendances#update_start_time', as: :update_start_time_attendance
    patch 'attendance/:id/update_end_time', to: 'attendances#update_end_time', as: :update_end_time_attendance
    patch 'attendance/:id/update_comments', to: 'attendances#update_comments', as: :update_comments_attendance
  end

    post 'sprint_goals/bulk_destroy', to: 'sprint_goals#bulk_destroy'

    resources :learner_flags, only: [:edit, :update]

    get 'topics_for_subject', to: 'weekly_goals#topics_for_subject'

    resources :subjects do
      resources :topics, except: [:show, :index]
    end

    resources :holidays, except: [:show, :index]

    resources :timelines do
      collection do
        get :personalized_new
        post :personalized_create
        patch :update_colors
        get :archived
        post :sync_moodle
      end
      member do
        patch :toggle_archive
        get :personalized_edit
        patch :personalized_update
        get :moodle_show
      end
    end

    get 'weekly_goals/week/', to: 'weekly_goals#navigator', as: :weekly_goals_navigator
    get 'weekly_goals/week/color_picker', to: 'weekly_goals#color_picker', as: :weekly_goals_color_picker

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

    resources :exam_dates, except: [:show]

    resources :sprint_goals do
      # member do
      #   delete :reset_associations, as: 'reset_associations' # Adds a custom delete route for resetting associations
      # end

      resources :knowledges, only: [:create, :update, :destroy] # Nested resources for knowledges
      resources :skills, only: [:create, :update, :destroy]     # Nested resources for skills
      resources :communities, only: [:create, :update, :destroy] # Nested resources for communities
    end

    resources :sprint_goals

    resources :kdas
    resources :user_topics do
      member do
        patch :toggle_done
      end
    end

    # match '*path', via: :all, to: 'pages#not_found'

    get 'reports_lc_view', to: 'reports#lc_view', as: 'lc_view'
    get 'reports_lc_index', to: 'reports#lc_index', as: 'lc_index'
    resources :reports do
      member do
        post 'toggle_hide'
        get 'report'
        patch 'update_knowledges'
        patch 'update_activities'
        post 'remove_lc'
      end
    end

    resources :notifications, only: [:index] do
      member do
        patch :mark_as_read
        delete :destroy
      end
      collection do
        patch :mark_all_as_read
      end
    end

    resources :forms, only: [:index, :show] do
      resources :responses, only: [:new, :create, :edit, :update]
    end

    resources :newsletters, only: [:index, :show, :new, :create, :edit, :update, :destroy]

    namespace :admin do
      resources :users, only: [:index, :edit, :update] do
        member do
          patch :update_hubs
        end
      end
    end

    resources :users, only: [] do
      resources :notes, except: [:show]
    end
    get 'moodle_index', to: 'timelines#moodle_index', as: :moodle_index

end
