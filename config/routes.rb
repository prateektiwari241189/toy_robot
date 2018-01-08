Rails.application.routes.draw do
	resources :robots, only: [:new,:create, :show]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'robots#new'

end
