ActionController::Routing::Routes.draw do |map|
  map.resources :satellites do |satellites|
    satellites.resources :positions
    satellites.resources :passes
  end
  map.root :controller => 'home', :action => 'index'
end
