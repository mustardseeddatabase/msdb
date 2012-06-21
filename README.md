# Mustard Seed Database: Food Pantry Software

Manages the three primary workflow of a food pantry operation:

  * **Verification of client eligibility** - when client checks in at the food pantry, prompts for re-verification of expired documentation. Verification documents include:
    * Verification of identification.
    * Proof of residency.
    * Proof of household income.
    * Eligibility documentation may be scanned and stored in the database.
    * Determination of extent of client eligibility based on household income and household size.
  * **Received donations** - Barcodes are scanned and non-barcode items assigned sku codes. Receiving of items is logged and added to current inventory.
  * **Food distribution** - Record distribution of food items to clients, resembling a supermarket checkout model.

Includes admistration facilities:

  * Inventory cycle count.
  * Resolve database to actual inventory.
  * Report generation (future).
  * Database validation.
  * Role-based access control. Long-term staff may be assigned access accounts. Access may be configured for temporary or short-term staff that limits privileges and expires at the end of the session.

Fully "skinnable" with your own color scheme and graphical elements (logo, navigation icons).

## Installation
Installation requires git, rubygems, bundler and ruby 1.9.3 to be installed on the host computer.

If these are not already present, follow the installation instructions for each of them at:

  * **ruby** - [ruby-lang.org](http://www.ruby-lang.org/en/downloads/)
  * **rubygems** - [rubygems.org](http://rubygems.org)
  * **bundler** - [gembundler.com](http://gembundler.com/)
  * **git** - [git-scm.com](http://git-scm.com/)

Download the code from github:

    git clone git://github.com/mustardseeddatabase/msdb.git

Or if you have a github account, fork the code into your account and download from there, later you will use your own account as a repo for your own customized version.

Install gem dependencies:

    cd msdb
    bundle

Create a database (the default database is sqlite, to facilitate installation. You will certainly wish to replace that with mySQL or Postgres, so edit config/database.yml appropriately).:

    rake db:schema:load

Prepare the test database:

    rake db:schema:load RAILS_ENV=test

Run the tests:

    bundle exec cucumber features
    bundle exec rspec spec

Run the javascript tests by starting the rails server:

    rails s

Then point a browser to localhost:3000/jasmine to view the test results.(This is achieved by means of the [jasminerice](https://github.com/bradphelan/jasminerice) gem)

If you wish to import your own data, rather than start with a clean slate, you will need to write rake tasks to map your existing database onto the tables in the application. Depending on the structure of your database, this can be a tricky endeavour. Verifying that the import has been correctly executed is a manual task and cannot easily be automated.

Bootstrap access accounts. Set up the first adminstrative account, from which other access accounts can be generated via the user interface.

Note that the command format has no spaces or quotes, the arguments are first name, last name, login and password.

    rake authengine:bootstrap[Harry,Harker,hhrocks,sekret]

A sample set of data may be loaded into the database so you can explore the application and get a feel for how it works. Load up the sample data with:

    rake msdb:preload

## Customize the color scheme and graphics

Run the rake task:

    rake msdb:create_theme

The theme's text elements (banner text and page title) may then be configured in config/locales/theme/en.yml.

All the images (logo and navigation icons) are combined in a single sprite, app/themes/custom/images/ms_sprite.png. Replace the elements in this image with images of your own.

Edit the stylesheets in app/themes/custom/stylesheets to render the pages with your own color scheme.

## Set up access accounts, roles and privileges

A bootstrap rake task is provided to configure the first admin account (see above). After the first account is configured, further accounts and roles may be added via the user interface.

Roles, with user-defined names, are configured, and access privileges are assigned to the roles. When a user account is added, the user is assigned one (or more) roles.

Since a food pantry operation may be staffed by a transient cast of volunteers, an account may be temporarily downgraded (for the duration of the session) so that the computer may be used for, for instance, client checkout, without exposing the full database to the temporary staffer.

Another account should be configured, and the default account removed. It is a serious security vulnerability to leave the default account configured.

## Making One-click Reports

The reports are generated as Microsoft Word documents, as this facilitates editing. Other formats, such as .html, .pdf, .xslx and .csv are possible by stipulating the format in the link that generates the report (or form action url), and supplying the required rendering handler.

Report generators are organized as rails engines in the vendor/gems directory, in order so that each report can keep its controller, views, routes, and templates in an isolated location, vs. sprinkled throughout the application.

A generator is provided that will generate an outline structure for a new report engine. Run:

    rails generate report my_report

and you will see in vendor/gems/my_report a new Rails engine that will produce Microsoft Word reports. An example report is included that you can use as a base to modify to suit your needs.

You will also need to add the new engine to the Gemfile as a dependency, so:

    # Gemfile
    gem 'my_report', :path => 'vendor/gems/my_report'

To fix this engine/gem in Gemfile.lock run:

    bundle install

The new report engine includes a view partial that includes a button that generates the report. There is also a form in the partial that allows the user to set a report parameter, e.g. month.

Include the partial in the reports#index view like this:

    render :partial => 'my_report/report.html.haml'

The form in this partial requires a model instance, so in the reports_controller.rb, create an instance of the new report:

    # in reports_controller.rb
    def index
      @my_report = MyReport::Report.new
    end

If you reboot your server and click on the button to generate a report, you'll see an error message indicating that permissions have not yet been configured for this action.

Therefore you must now go to the admin page and manage access privileges for the new report. The route you will be configuring is my_report/reports#show.

== Deployment tips

For performance reasons it's a good idea to cache the barcode images that are generated in the sku list with barcodes document. If you are using Capistrano, you can use this:

    # in config/deploy.rb
    namespace :application do
      desc "symlinks the barcode images to a cache in the shared directory that survives code update"
      task :symlink_barcode_image_cache do
        run "mkdir -p #{release_path}/tmp/cache"
        run "ln -nfs #{shared_path}/barcode_images #{release_path}/tmp/cache/barcode_images"
      end
    end

    after "deploy:assets:precompile", "application:symlink_barcode_image_cache"

(it's linked after precompiling because the images are created in tmp/cache, and assets:precompile apparently clobbers this during precompiling!)
