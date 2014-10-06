RailsAssets::Application.routes.draw do
  get '/packages' => 'main#packages'
  get '/packages/:name' => 'main#package',
    constraints: { name: /[^\/]+/ }

  get '/latest_specs.4.8' => 'main#index_files'
  get '/latest_specs.4.8.gz' => 'main#index_files'
  get '/prerelease_specs.4.8' => 'main#index_files'
  get '/prerelease_specs.4.8.gz' => 'main#index_files'
  get '/specs.4.8' => 'main#index_files'
  get '/specs.4.8.gz' => 'main#index_files'

  get '/gems/*path' => 'main#gem_files'
  get '/quick/*path' => 'main#gem_files'

  resources :components, only: [:index, :new, :create] do
    collection do
      get '/:name/:version' => 'components#assets',
        constraints: { version: /[^\/]+/, name: /[^\/]+/ }
    end
  end

  get "/api/v1/dependencies", to: "main#dependencies"

  require 'sidekiq/web'
  Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
    [user, password] == [
      "admin", ENV['SIDEKIQ_PASSWORD'] || "password"
    ]
  end
  mount Sidekiq::Web => '/sidekiq'

  get '/status', to: 'main#status'

  root to: "main#home"

  get '/home', to: redirect('/')

  match '(errors)/:status', to: 'errors#show',
    constraints: { status: /\d{3}/ },
    defaults: { status: '500' },
    via: :all
end
