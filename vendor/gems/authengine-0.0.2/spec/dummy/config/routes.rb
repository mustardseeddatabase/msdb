Rails.application.routes.draw do
  mount Authengine::Engine => "/authengine"
end
