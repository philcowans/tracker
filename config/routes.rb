ActionController::Routing::Routes.draw do |map|
  map.resources :satellites do |satellites|
    satellites.resources :positions
  end
end
