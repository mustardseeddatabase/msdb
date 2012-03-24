namespace :msdb do
  desc 'create custom theme'
  task :create_theme do
    sh "cp -r #{Rails.root.join('app','themes','default')} #{Rails.root.join('app','themes','custom')}"
    sh "cp #{Rails.root.join('lib/templates/en.yml')} #{Rails.root.join('config','locales','en.yml')}"
  end
end
