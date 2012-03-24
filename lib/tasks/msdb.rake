namespace :msdb do
  desc 'create custom theme'
  task :create_theme do
    sh "cp -r #{Rails.root.join('app','themes','default')} #{Rails.root.join('app','themes','custom')}"
    sh "mv #{Rails.root.join('app', 'themes', 'custom', 'assets', 'stylesheets', 'default.css')} #{Rails.root.join('app', 'themes', 'custom', 'assets', 'stylesheets', 'custom.css')}"
    sh "cp #{Rails.root.join('lib/templates/en.yml')} #{Rails.root.join('config','locales','en.yml')}"
  end
end
