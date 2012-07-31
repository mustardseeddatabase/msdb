namespace :authengine do
  desc 'create an admin access account, only when there are no accounts already configured. Call rake authengine:bootstrap[firstname,lastname,login,password] (no spaces, no quotes)'
  task :bootstrap, [:firstName, :lastName, :login, :password] => :environment do |t, args|
    if args.to_hash.keys.length < 4
      puts "Please specify firstname, lastname, login and password"
    else
      if User.count > 0
        puts "There is already a user account present, you may only bootstrap the first account"
      else
        attributes = {:firstName => args[:firstName],
                      :lastName  => args[:lastName],
                      :login     => args[:login],
                      :password  => args[:password],
                      :password_confirmation => args[:password]}
        if id = User.create_by_sql(attributes)
          puts "Creating account for #{attributes[:firstName]} #{attributes[:lastName]} login: #{attributes[:login]}, password #{attributes[:password]}"
        end
      end
    end

    if
      user = User.find(id)
      role = Role.create(:name => 'admin')
      user.roles << role
      Controller.update_table
      ActionRole.bootstrap_access_for(role)
    end
  end
end
