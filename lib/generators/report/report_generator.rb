class ReportGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def generate_report_engine
    if File.exists? "vendor/gems/#{file_name}"
      puts "\r\nThe #{file_name} report is already installed in vendor/gems, if you wish to replace it, delete it first."
    else
      copy_template
    end
  end

private

  def copy_template
    copy_file 'report_engine/app/controllers/reports_controller.rb', "vendor/gems/#{file_name}/app/controllers/#{file_name}/reports_controller.rb"
    gsub_file "vendor/gems/#{file_name}/app/controllers/#{file_name}/reports_controller.rb", /NAMESPACE/, "#{file_name.camelize}"
    gsub_file "vendor/gems/#{file_name}/app/controllers/#{file_name}/reports_controller.rb", /report_name/, "#{file_name}"
    copy_file 'report_engine/app/models/report.rb', "vendor/gems/#{file_name}/app/models/#{file_name}/report.rb"
    gsub_file "vendor/gems/#{file_name}/app/models/#{file_name}/report.rb", /NAMESPACE/, "#{file_name.classify}"
    copy_file 'report_engine/app/views/report/_report.html.haml', "vendor/gems/#{file_name}/app/views/#{file_name}/_report.html.haml"
    gsub_file "vendor/gems/#{file_name}/app/views/#{file_name}/_report.html.haml", /object/, "#{file_name}"
    gsub_file "vendor/gems/#{file_name}/app/views/#{file_name}/_report.html.haml", /path/, "#{file_name}_path"
    gsub_file "vendor/gems/#{file_name}/app/views/#{file_name}/_report.html.haml", /report_text/, "#{file_name.humanize}"
    copy_file 'report_engine/config/application.rb', "vendor/gems/#{file_name}/config/application.rb"
    create_file "vendor/gems/#{file_name}/config/routes.rb", "Rails.application.routes.draw { match '#{file_name}/report(.:format)' => '#{file_name}/reports#show', :as => '#{file_name}'}"
    create_file "vendor/gems/#{file_name}/lib/#{file_name}.rb", "require '#{file_name}/engine'"
    copy_file 'report_engine/lib/report/engine.rb', "vendor/gems/#{file_name}/lib/#{file_name}/engine.rb"
    gsub_file "vendor/gems/#{file_name}/lib/#{file_name}/engine.rb", /ENGINE_NAME/, "#{file_name.camelize}"
    create_file "vendor/gems/#{file_name}/lib/#{file_name}/version.rb", "module #{file_name.camelize}; VERSION = '0.0.1'; end"
    copy_file "report_engine/report.gemspec", "vendor/gems/#{file_name}/#{file_name}.gemspec"
    gsub_file "vendor/gems/#{file_name}/#{file_name}.gemspec", /ENGINE_NAME/, "#{file_name.camelize}"
    gsub_file "vendor/gems/#{file_name}/#{file_name}.gemspec", /engine_name/, "#{file_name}"
    directory "report_engine/app/document_templates/report", "vendor/gems/#{file_name}/app/document_templates/#{file_name}"
  end
end
