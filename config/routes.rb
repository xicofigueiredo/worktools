Rails.application.routes.draw do
  resources :moodle_assignments, only: [:index, :show] do
    collection do
      post :fetch_submissions_range
      get 'subject/:id', to: 'moodle_assignments#subject', as: :subject
    end
  end
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

    # Role switching for admins
    post '/switch_role', to: 'application#switch_role', as: 'switch_role'

    get 'after_signup', to: 'users/registrations#after_signup', as: 'after_signup'
    get 'profile', to: 'pages#profile'
    get 'edit_profile', to: 'pages#edit_profile'
    post '/update_profile', to: 'pages#update_profile', as: :update_profile
    get '/get_topics', to: 'subjects#get_topics'
    patch '/timelines/:id/update_done_topics', to: 'timelines#update_done_topics', as: 'update_done_topics'
    get '/about', to: 'pages#about'

    resources :consents, only: [] do
      collection do
        get :build_week
        post :build_week, action: :create_build_week
        get :sprint
        post :sprint, action: :create_sprint
        get :navigator, path: 'build_weeks/navigator'
        get :manage_activities, path: 'build_weeks/activities'
        patch :update_activities, path: 'build_weeks/activities'
        post :create_activity, path: 'build_weeks/activities'
        patch :update_activity, path: 'build_weeks/activities/:id'
        delete :destroy_activity, path: 'build_weeks/activities/:id'
      end
    end

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

    # Admissions list
    resources :admissions, controller: 'admission_list', only: [:index, :show, :update, :new, :create] do
      collection do
        get 'export', action: :export_form
        post 'export', action: :export_csv
        post 'fetch_from_hubspot', action: :fetch_from_hubspot
        post 'generate_bulk_emails', action: :generate_bulk_emails
      end
      member do
        get 'documents', action: :documents
        post 'documents', action: :create_document
        patch 'documents/:document_id', action: :update_document
        delete 'documents/:document_id', action: :destroy_document, as: 'document'
        get 'check_pricing_impact', action: :check_pricing_impact
      end
    end

    resources :hubs, only: [:index, :show] do
      member do
        get :calendar
      end

      resource :booking_config, controller: 'hub_booking_configs', only: [:create, :update]

      resources :hub_visits, only: [:new, :create] do
        collection do
          get :available_slots
        end
      end
    end

    resources :pricing_tiers, only: [:index, :create, :update, :destroy]

    resources :service_requests, only: [:index, :create] do
      collection do
        get :fetch_learners
      end
    end

    resources :confirmations, only: [] do
      member do
        post :approve
        post :reject
      end
    end

    resources :public_holidays, only: [:create, :destroy]
    resources :blocked_periods, only: [:create, :destroy]
    resources :mandatory_leaves, only: [:create, :destroy]

    resources :leaves, only: [:index, :new, :create, :show] do
      collection do
        get :leave_history
        post :preview
        post :update_entitlement
        post :create_entitlement
        get :users_without_entitlement
      end

      member do
        post :cancel
        delete 'documents/:doc_id', to: 'leaves#delete_document', as: 'delete_document'
        get 'documents/:doc_id/download', to: 'leaves#download_document', as: 'download_document'
      end
    end

    resources :holidays, except: [:show, :index]

    resources :timelines do
      collection do
        get :personalized_new
        post :personalized_create
        patch :update_colors
        get :archived
      end
      member do
        patch :toggle_archive
        get :personalized_edit
        patch :personalized_update
        get :moodle_show
      end
    end

    resources :moodle_timelines do
      member do
        post :update_topics
        get :moodle_show
        patch :toggle_archive
      end
      collection do
        get :archived
        post :sync_moodle
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
        delete 'destroy_report_knowledge', to: 'reports#destroy_report_knowledge'
        post 'reset_knowledges_from_sprint_goal', to: 'reports#reset_knowledges_from_sprint_goal'
      end
    end

    resource :csc_diploma, only: [:show] do
      post :fetch_activities, on: :member
    end

    resources :csc_activities, only: [:edit, :update] do
      member do
        patch :toggle_hidden
        delete :purge_attachment
      end
    end

    resources :notifications, only: [:index, :new, :create] do
      member do
        patch :mark_as_read
        patch :mark_as_unread
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

    resources :exam_enrolls do
      member do
        patch :update_paper_costs
        post :remove_lc
        get :download_document
        delete :delete_document
      end
      collection do
        get :select_learner
        get :select_timeline
        get :select_exam_date
      end
    end

    resources :exam_finances do
      member do
        get :generate_statement
        get :preview_statement
      end
    end

    resources :assignments, only: [:index] do
      collection do
        get :show_detailed
        get :assignment_statistics
        get :monthly_submissions
        get :monthly_submissions_local
        get :monthly_submissions_local_overview
        post :sync
      end
    end

    # Chat routes for AI tutor
    resources :chats do
      member do
        post :send_message
      end
    end

end
