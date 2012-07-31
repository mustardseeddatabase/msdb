User.reset_column_information
    user = User.create(:login => 'admin', 
                :email => 'user@example.com',
                :enabled => true,
                :firstName => 'A',
                :lastName => 'User')
    user.update_attribute(:salt, '1641b615ad281759adf85cd5fbf17fcb7a3f7e87')
    user.update_attribute(:activation_code, '9bb0db48971821563788e316b1fdd53dd99bc8ff')
    user.update_attribute(:activated_at, DateTime.new(2011,1,1))
    user.update_attribute(:crypted_password, '660030f1be7289571b0467b9195ff39471c60651')

    # in the bootstrap scenario, give the administrative user enough
    # access to be able to configure the access tables for admin and other users
    role = Role.create(:name => 'developer')
    Controller.update_table
    Action.all.each { |a| role.actions << a  }
    user.roles << role
    user.save


