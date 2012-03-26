I18n.load_path += Dir[Rails.root.join("config","locales","**","*.yml")] # in order to use the i18n theme control this early in the boot
Rails.application.config.assets.paths << Rails.root.join("app", "themes", I18n.translate( :theme), "assets").to_s
Rails.application.config.assets.paths << Rails.root.join("app", "themes", I18n.translate( :theme), "assets", "images").to_s
