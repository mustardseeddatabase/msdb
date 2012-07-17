module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      home_path
    when /the admin#index page/
      admin_index_path
    when /the authengine\/users#index page/
      authengine_users_path
    when /the authengine\/roles#index page/
      authengine_roles_path
    when /the authengine\/actions#index page/
      authengine_actions_path
    when /activation url with a valid activation code/
      "/authengine/activate/123456789abcdef"
    when /activation url with no activation code/
      "/authengine/activate"
    when /the intake page/
      new_household_path
    when /the households#index page/
      households_path
    when /the households#index\?([^ ]*) page/
      # here we interpret a query string
      qstring = $1
      qterms = $1.split('&')
      qhash = qterms.inject({}){ |hash, term| name, value = term.split('='); hash.merge!(name.to_sym => value); hash}
      households_path(qhash)
    when /the households#edit page/
      edit_household_path(Household.first.id)
    when /the households#show page/
      household_path(Household.first.id)
    when /the household_clients#new page/
      new_household_household_client_path(Household.first.id)
    when /the client quickcheck page/
      qualification_documents_path
    when /the clients#index page/
      clients_path
    when /the client#show page for "(.*)"/
      last_name = $1.split[1]
      client_path(Client.find_by_lastName(last_name))
    when /the donations#index page/
      donations_path
    when /the donors#new page/
      new_donor_path
    when /the donations#new page/
      donor = Donor.find_by_organization("Food for All")
      new_donor_donation_path(donor.id)
    when /the distributions#index page/
      distributions_path
    when /the distributions#new page for "([^"]*)"/
      last_name = $1.split[1]
      new_client_distribution_path(Client.find_by_lastName(last_name))
    when /the limit_categories#index page/
      limit_categories_path
    when /the items#index page/
      items_path
    when /the item status page/
      item_path(:id => 'undefined',:format => :html)
    when /the inventories#new page/
      new_inventory_path
    when /the inventories#show page for the inventory on (.*)/
      date = Date.parse($1)
      inventory = Inventory.all.detect { |d| d.created_at.to_date == date }
      inventory_path(inventory)
    when /the inventories#edit page for the inventory on (.*)/
      date = Date.parse($1)
      inventory = Inventory.all.detect { |d| d.created_at.to_date == date }
      edit_inventory_path(inventory)
    when /the sku_lists#show page/
      sku_list_path

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
