Rails.application.routes.draw do
  mount Blacklight::Oembed::Engine, at: 'oembed'
  mount Riiif::Engine => '/images', as: 'riiif'
  root to: 'spotlight/exhibits#index'
  mount Spotlight::Engine, at: 'spotlight'
  mount Blacklight::Engine => '/'
  #  root to: "catalog#index" # replaced by spotlight root path
  concern :searchable, Blacklight::Routes::Searchable.new

  # resources :exhibit_finder, only: %i[show index]

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
  end
  devise_for :users
  concern :exportable, Blacklight::Routes::Exportable.new

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # allow routing to masked pages
  scope module: 'spotlight' do
    get '/admin_users/clear_mask_role', to: 'admin_users#clear_mask_role'
    get '/admin_users/mask_role/:role', to: 'admin_users#mask_role'
  end

  authenticate :user, ->(u) { u.superadmin? } do
    mount DelayedJobWeb, at: '/delayed_job'
  end

  match '*unmatched', to: 'application#not_found', via: :all
end
