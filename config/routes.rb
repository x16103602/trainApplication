require 'resque/server'
Rails.application.routes.draw do
  mount Resque::Server.new, at: "/resque"
  mount RailsAdmin::Engine => '/dashboard', as: 'rails_admin'
  resources :longtrains
  resources :tickets
  resources :charges
  get 'sessions/create'
  #get 'home/navigator'
  #get 'home/navigator'
  #get 'home/navigator'
  match 'tickethistory', to: 'home#tickethistory', via: [:get, :post]
  match 'bookticket', to: 'home#bookticket', via: [:get, :post]
  match 'payment', to: 'home#payment', via: [:get, :post]
  match 'ticketconfirmation', to: 'home#ticketconfirmation', via: [:get, :post]
  match 'stripecash', to: 'home#stripecash', via: [:get, :post]
  match 'checker', to: 'home#ticketcheck', via: [:get, :post]
  match 'ticketcheckerresult', to: 'home#ticketcheckerresult', via: [:get, :post]
  match 'home', to: 'home#navigator', via: [:get, :post]
  match 'admin', to: 'home#admin', via: [:get, :post]

  match 'longtraincreation', to: 'longtrains#longtraincreation', via: [:get, :post]
  match 'administrator', to: 'longtrains#traininstantiation', via: [:get, :post]
  match 'longtrainbook', to: 'longtrains#longtrainbook', via: [:get, :post]
  match 'showonly', to: 'longtrains#showonly', via: [:get, :post]
  match 'longtrainindex', to: 'longtrains#longtrainindex', via: [:get, :post]
  match 'longtraincancellation', to: 'longtrains#longtraincancel', via: [:get, :post]
  
  match 'pdfticket', to: 'home#pdfticket', via: [:get, :post]
  
  resources :homes
  root "home#index" 
  #get 'home/index'
  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: redirect("/") , via: [:get, :post]
  match 'signout', to: 'sessions#signout', via: [:get, :post]
  match 'customtweets', to: 'welcome#customtweets', via: [:get]
  match 'morecustomtweets', to: 'welcome#morecustomtweets', via: [:get]
  match 'twittertrends', to: 'welcome#twittertrends', via: [:get, :post]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
