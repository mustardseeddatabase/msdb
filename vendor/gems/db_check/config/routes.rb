Rails.application.routes.draw do
  match "db_check" => "db_check#index", :as => :db_check
  match "db_check/:check_type" => "db_check#show"
end
