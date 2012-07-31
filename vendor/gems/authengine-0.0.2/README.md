# Usage

Add authengine to your Gemfile:

     gem 'authengine'

And in the host application run:

     bundle install

In config/application.rb, configure the generator for haml by including:

     config.generators do |g|
     # Configure haml to be the default templating engine for generators
       g.template_engine :haml
     end

Then copy the authengine migrations and initializer to your application and modify your application.html.rb to use the authengine with:

     rails generate authengine

The database is initialized with the default username: admin and password: password be sure to delete this user once the real administrator has been created.

When logged in, the preconfigured admin user is assigned to the 'developer' role, which grants permissions to all controllers and actions. Additional users, roles and permissions may then be granted.

# Layout

The content for the authengine views is rendered as:

    content_for(:authengine_logout) # for the logout link

and:

    content_for(:authengine) # for the main page content

In your layouts/application.html.haml template, include these view components by including:

     =  yield(:authengine_logout)

and to include both the application content and the authengine content:

     =  content_for?(authengine) ? yield(:authengine) : yield

In order to include the Administration and Logout links in pages that are not produced by authengine, include in the head element of your application.html.haml layout file:

     = stylesheet_link_tag "authengine"

# Admin_logout helper

A helper is available called admin_logout, which should be included in all views.

For non administrative users, it renders a logout link. For administrative users, it renders both a link to the admin portal, and also a logout link.

The admin and logout links are wrapped in a div#authengine_logout to facilitate styling and positioning.

# Roles

When a user is logged in with a role that matches (case insensitive) 'admin' (e.g. Administrator, foo_admin), they will be able to see the link to the administration portal, which is a menu of links to other administration pages.

# Application Name

The name of the application is used in some views, and particularly in user activation emails, set the constant APPLICATION_NAME to your own application's name.

# Privacy Policy

If you wish to have new users read and agree to a privacy policy, then the policy should be included in app/views/authengine/users/_privacy_policy.html.haml of your application. A template is copied into this directory when the authengine generator is run. Delete this template if you do not want the user to see it.

# Testing

In the head section of your application's application.html.haml layout file, include

    - content_for :head

This will include a javascript snippet that facilitates integration testing with cucumber/capybara. The script 'bypasses' any js calls to alert or confirm.

# Rspec tests

cd into the root directory of the application and run

    bundle exec rspec

# TODO

* describe feature testing
* describe application_controller before_filter
* copy message_block images in generator
