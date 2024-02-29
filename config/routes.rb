Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'user_sessions',
    passwords: 'users/passwords',
    omniauth_callbacks: "omniauth_callbacks"
  }

  resources :users, only: [:show]

  root 'static_pages#top'
  
  get 'terms', to: 'static_pages#terms', as: :terms
  get 'privacy_policy', to: 'static_pages#privacy_policy', as: :privacy_policy

  # LINE通知設定へのルーティング
  get 'line_notification_settings', to: 'line_notifications#edit', as: 'line_notification_settings'
  patch 'line_notification_settings', to: 'line_notifications#update'
  post 'notify_callback', to: 'line_notifications#notify_callback'

  # 野菜選択画面へのルーティング
  get 'vegetables', to: 'vegetables#index', as: :vegetables
  
  # 野菜選択後のスケジュール表示アクションへのルーティング
  get 'vegetables/schedule', to: 'vegetables#schedule', as: :vegetable_schedule

  # 収穫アクションへのルーティング
  

  # Eventsに関するルーティング
  resources :events, only: [:index, :show] do
    member do
      get 'advice'
      patch 'complete'
    end
  end

  patch '/events/update_sowing_date', to: 'events#update_sowing_date', as: 'update_sowing_date_events'

  # 収穫量の入力フォームと節約額の計算結果表示のルーティング
  resources :harvests, only: [:new, :create, :show]

  # データを削除するための機能
  resources :harvests do
    collection do
      delete 'destroy_by_vegetable_type'
    end
  end
end  