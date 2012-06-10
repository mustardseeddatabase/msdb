Rails.application.routes.draw { match 'second_harvest_monthly_report/report(.:format)' => 'second_harvest_monthly_report/reports#show', :as => 'second_harvest_monthly_report'}
